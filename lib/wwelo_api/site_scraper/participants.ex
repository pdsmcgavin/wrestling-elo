defmodule WweloApi.SiteScraper.Participants do
  import Ecto.Query

  alias WweloApi.Repo
  alias WweloApi.Stats
  alias WweloApi.Stats.Participant
  alias WweloApi.SiteScraper.Aliases
  alias WweloApi.SiteScraper.Wrestlers

  def save_participants_of_match(%{
        match_id: match_id,
        match_result: match_result
      }) do
    participants =
      convert_result_to_participant_info(%{
        match_id: match_id,
        match_result: match_result
      })

    case participants do
      nil ->
        nil

      _ ->
        participants
        |> Enum.map(
          &(get_and_add_alias_id(&1)
            |> save_participant_to_database)
        )
    end
  end

  def convert_result_to_participant_info(%{
        match_id: match_id,
        match_result: match_result
      }) do
    case split_result_into_winners_and_losers(%{match_result: match_result}) do
      %{winners: winners, losers: losers} ->
        winners =
          winners |> split_participants_into_teams(" and ")
          |> Enum.map(&remove_managers(&1))

        losers =
          losers |> split_participants_into_teams(" and ", length(winners))
          |> Enum.map(&remove_managers(&1))

        [{winners, "win"}, {losers, "loss"}]
        |> Enum.map(&convert_participant_info(&1))
        |> List.flatten()
        |> Enum.filter(&(!is_nil(&1)))
        |> Enum.map(&Map.put(&1, :match_id, match_id))

      %{drawers: drawers} ->
        drawers =
          drawers |> split_participants_into_teams(" vs. ")
          |> Enum.map(&remove_managers(&1))

        [{drawers, "draw"}]
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
      [drawers] -> %{drawers: drawers}
      _ -> nil
    end
  end

  def split_participants_into_teams(
        participants,
        split_by,
        offset \\ 0
      ) do
    participants
    |> Enum.chunk_by(fn x ->
      is_bitstring(x) && String.contains?(x, split_by)
    end)
    |> Enum.filter(fn x ->
      !Enum.any?(x, &(is_bitstring(&1) && String.contains?(&1, split_by)))
    end)
    |> Enum.with_index(offset)
  end

  def remove_managers({participants, match_team}) do
    participants =
      participants
      |> Enum.chunk_by(fn x ->
        is_bitstring(x) && String.contains?(x, "w/")
      end)
      |> Enum.at(0)

    {participants, match_team}
  end

  def convert_participant_info({participants, outcome}) do
    participants
    |> Enum.map(fn {team, match_team} ->
      team
      |> Enum.map(fn participant ->
        case participant do
          {_, [{_, "?id=2&" <> url}], [alias]} ->
            %{
              alias: alias,
              profile_url: "?id=2&" <> url,
              outcome: outcome,
              match_team: match_team
            }

          _ ->
            nil
        end
      end)
    end)
  end

  def get_and_add_alias_id(participant_info) do
    alias_id = Aliases.get_alias_id(participant_info.alias)

    alias_id =
      case alias_id do
        nil ->
          Wrestlers.save_alter_egos_of_wrestler(%{
            wrestler_url_path: participant_info.profile_url
          })

          new_alias_id = Aliases.get_alias_id(participant_info.alias)

          case new_alias_id do
            nil ->
              Aliases.get_alias_id(
                # For The Velveteen Dream edge case
                participant_info.alias
                |> String.trim_leading("The ")
              )

            _ ->
              new_alias_id
          end

        _ ->
          alias_id
      end

    participant_info
    |> Map.put(
      :alias_id,
      alias_id
    )
  end

  def save_participant_to_database(participant_info) do
    participant_query =
      from(
        p in Participant,
        where:
          p.match_id == ^participant_info.match_id and
            p.alias_id == ^participant_info.alias_id,
        select: p
      )

    participant_result = Repo.one(participant_query)

    case participant_result do
      nil -> Stats.create_participant(participant_info) |> elem(1)
      _ -> participant_result
    end
    |> Map.get(:id)
  end
end
