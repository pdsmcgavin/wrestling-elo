defmodule WweloApi.SiteScraper.Participants do
  import Ecto.Query

  alias WweloApi.Repo
  alias WweloApi.Stats
  alias WweloApi.Stats.Participant

  def save_participants_of_match(%{
        match_id: match_id,
        match_result: match_result
      }) do
    convert_result_to_participant_info(%{
      match_id: match_id,
      match_result: match_result
    })
  end

  def convert_result_to_participant_info(%{
        match_id: match_id,
        match_result: match_result
      }) do
    case split_result_into_winners_and_losers(%{match_result: match_result}) do
      %{winners: winners, losers: losers} ->
        winners = winners |> split_participants_into_teams
        losers = losers |> split_participants_into_teams(length(winners))

        [{winners, "win"}, {losers, "loss"}]
        |> Enum.map(&convert_participant_info(&1))
        |> List.flatten()
        |> Enum.filter(&(!is_nil(&1)))
        |> Enum.map(&Map.put(&1, :match_id, match_id))

      nil ->
        nil
    end
  end

  def split_result_into_winners_and_losers(%{match_result: match_result}) do
    split_results =
      match_result
      |> Enum.chunk_by(fn x ->
        is_bitstring(x) && String.contains?(x, "defeat")
      end)

    case split_results do
      [winners, _, losers] -> %{winners: winners, losers: losers}
      _ -> nil
    end
  end

  def split_participants_into_teams(participants, offset \\ 0) do
    participants
    |> Enum.chunk_by(fn x ->
      is_bitstring(x) && String.contains?(x, " and ")
    end)
    |> Enum.filter(fn x ->
      !Enum.any?(x, &(is_bitstring(&1) && String.contains?(&1, " and ")))
    end)
    |> Enum.with_index(offset)
  end

  def convert_participant_info({participants, outcome}) do
    participants
    |> Enum.map(fn {team, match_team} ->
      team
      |> Enum.map(fn participant ->
        case participant do
          {_, [{_, url}], [alias]} ->
            %{
              alias: alias,
              profile_url: url,
              outcome: outcome,
              match_team: match_team
            }

          _ ->
            nil
        end
      end)
    end)
  end

  def save_participant_to_database(participant_info) do
    participant_query =
      from(
        p in Participant,
        where:
          p.match_id == ^participant_info.match_id and
            p.wrestler_id == ^participant_info.wrestler_id,
        select: p
      )

    participant_result = Repo.one(participant_query)

    case participant_result do
      nil -> Stats.create_participant(participant_info) |> elem(1)
      _ -> participant_result
    end
  end
end
