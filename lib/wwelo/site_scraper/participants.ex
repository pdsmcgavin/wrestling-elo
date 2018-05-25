defmodule Wwelo.SiteScraper.Participants do
  @moduledoc false

  import Ecto.Query

  alias Wwelo.Repo
  alias Wwelo.Stats
  alias Wwelo.Stats.Participant
  alias Wwelo.SiteScraper.Aliases
  alias Wwelo.SiteScraper.Wrestlers

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
        |> Enum.map(fn participant ->
          participant
          |> get_and_add_alias_id
          |> save_participant_to_database
        end)
    end
  end

  def convert_result_to_participant_info(%{
        match_id: match_id,
        match_result: match_result
      }) do
    case split_result_into_winners_and_losers(%{match_result: match_result}) do
      %{winners: winners, losers: losers} ->
        winners =
          winners
          |> split_participants_into_teams(" and ")
          |> Enum.map(&remove_managers(&1))

        losers =
          losers
          |> split_participants_into_teams(" and ", length(winners))
          |> Enum.map(&remove_managers(&1))

        [{winners, "win"}, {losers, "loss"}]
        |> Enum.map(&convert_participant_info(&1))
        |> List.flatten()
        |> Enum.filter(&(!is_nil(&1)))
        |> Enum.map(&Map.put(&1, :match_id, match_id))

      %{drawers: drawers} ->
        drawers =
          drawers
          |> split_participants_into_teams(" vs. ")
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

  defp split_result_into_winners_and_losers(%{match_result: match_result}) do
    split_results =
      match_result
      |> Enum.chunk_by(fn x ->
        is_bitstring(x) && String.contains?(x, "defeat")
      end)

    case split_results do
      [winners, _, losers] ->
        %{winners: winners, losers: losers}

      [winners, losers] ->
        split_results_into_jobbers(winners, losers)

      [[jobbers]] ->
        split_results_into_jobbers(jobbers)

      [drawers] ->
        %{drawers: drawers}

      _ ->
        nil
    end
  end

  def split_results_into_jobbers(jobbers) do
    split_results = jobbers |> String.split(" defeats ")

    case split_results do
      [winners, losers] ->
        %{winners: [%{jobbers: winners}], losers: [%{jobbers: losers}]}

      _ ->
        nil
    end
  end

  def split_results_into_jobbers([winners], losers)
      when is_bitstring(winners) do
    [winners, _] = winners |> String.split(" defeats ")

    %{winners: [%{jobbers: winners}], losers: losers}
  end

  def split_results_into_jobbers(winners, [losers]) when is_bitstring(losers) do
    [_, losers] = losers |> String.split(" defeats ")

    %{winners: winners, losers: [%{jobbers: losers}]}
  end

  defp split_participants_into_teams(
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

  defp remove_managers({participants, match_team}) do
    participants =
      participants
      |> Enum.chunk_by(fn x ->
        is_bitstring(x) && String.contains?(x, "w/")
      end)
      |> Enum.at(0)

    {participants, match_team}
  end

  # credo:disable-for-lines:20
  defp convert_participant_info({participants, outcome}) do
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

          %{jobbers: jobber_name} ->
            %{
              alias: clean_jobber_name(jobber_name),
              profile_url: nil,
              outcome: outcome,
              match_team: match_team
            }

          _ ->
            nil
        end
      end)
    end)
  end

  def clean_jobber_name(jobber_name) do
    Regex.replace(~r/ \[.+\]/, jobber_name, "")
  end

  defp get_and_add_alias_id(participant_info) do
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

  defp save_participant_to_database(participant_info) do
    participant_query =
      from(
        p in Participant,
        where:
          p.match_id == ^participant_info.match_id and
            p.alias_id == ^participant_info.alias_id,
        select: p
      )

    participant_result = Repo.one(participant_query)

    participant_result =
      case participant_result do
        nil -> participant_info |> Stats.create_participant() |> elem(1)
        _ -> participant_result
      end

    participant_result |> Map.get(:id)
  end
end
