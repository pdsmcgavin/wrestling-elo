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

    %{match_result: match_result}
  end

  def convert_result_to_participant_info(%{
        match_id: match_id,
        match_result: match_result
      }) do
    split_result_into_winners_and_losers(%{match_result: match_result})
    |> Enum.map(&Map.put(&1, :match_id, match_id))
  end

  def split_result_into_winners_and_losers(%{match_result: match_result}) do
    [winners, _, losers] =
      match_result
      |> Enum.chunk_by(fn x ->
        is_bitstring(x) && String.contains?(x, "defeat")
      end)

    (convert_participant_info(winners, "win", 0) ++
       convert_participant_info(losers, "loss", 1))
    |> Enum.filter(&(!is_nil(&1)))
  end

  def convert_participant_info(participants, outcome, match_team) do
    participants
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
          IO.inspect(participant)
          nil
      end
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
