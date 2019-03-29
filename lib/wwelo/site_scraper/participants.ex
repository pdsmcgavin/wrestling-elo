defmodule Wwelo.SiteScraper.Participants do
  @moduledoc false

  require Logger

  import Ecto.Query

  alias Wwelo.Repo
  alias Wwelo.Stats
  alias Wwelo.Stats.Match
  alias Wwelo.Stats.Participant
  alias Wwelo.SiteScraper.Aliases
  alias Wwelo.SiteScraper.Wrestlers

  @spec save_participants_of_match(map) :: [integer] | nil
  def save_participants_of_match(%{
        match_id: match_id,
        match_result: match_result
      }) do
    participants =
      convert_result_to_participant_info(%{
        match_id: match_id,
        match_result: match_result
      })

    cond do
      participants == [] ->
        Logger.error(
          "Participants not found" <>
            Poison.encode!(%{
              match_id: match_id
            })
        )

        Match |> Repo.get!(match_id) |> Repo.delete()
        nil

      Enum.any?(participants, fn participant -> participant.alias == "???" end) ->
        Match |> Repo.get!(match_id) |> Repo.delete()
        nil

      true ->
        participants
        |> Enum.map(fn participant ->
          participant
          |> get_and_add_alias_id
          |> save_participant_to_database
        end)
    end
  end

  def convert_result_to_participant_info(%{
        match_result: match_result,
        match_id: match_id
      }) do
    match_result
    |> find_and_split_out_jobbers
    |> Enum.filter(&(&1 != ""))
    |> clean_up_tag_teams
    |> remove_things_between_brackets
    |> split_by_outcome_and_team
    |> Enum.map(&convert_participant_info(&1))
    |> List.flatten()
    |> Enum.filter(&(!is_nil(&1)))
    |> Enum.map(&Map.put(&1, :match_id, match_id))
  end

  def find_and_split_out_jobbers(match_result) do
    match_result
    |> Enum.reduce(
      [],
      fn x, acc ->
        new_info =
          cond do
            is_tuple(x) ->
              [x]

            is_bitstring(x) ->
              x
              |> String.split(~r/[,&\(\)\[\]]|and|defeats?|vs\./,
                include_captures: true
              )
              |> Enum.map(&String.trim(&1))

            x ->
              x
          end

        acc ++ new_info
      end
    )
  end

  # credo:disable-for-lines:52
  def clean_up_tag_teams(array) do
    array
    |> Enum.reduce(
      %{tag_team_found: false, brackets: 0, new_array: []},
      fn x, acc ->
        if acc.tag_team_found do
          case x do
            "(" ->
              Map.put(acc, :brackets, acc.brackets + 1)

            ")" ->
              acc =
                if acc.brackets > 0 do
                  acc |> Map.put(:brackets, acc.brackets - 1)
                else
                  acc
                end

              acc |> Map.put(:tag_team_found, false)

            text ->
              acc =
                if acc.brackets == 0 do
                  acc |> Map.put(:tag_team_found, false)
                else
                  acc
                end

              acc |> Map.put(:new_array, acc.new_array ++ [text])
          end
        else
          case x do
            {_, [{"href", "?id=28" <> _}], _} ->
              Map.put(acc, :tag_team_found, true)

            {_, [{"href", "?id=29" <> _}], _} ->
              Map.put(acc, :tag_team_found, true)

            "Team RAW" ->
              Map.put(acc, :tag_team_found, true)

            "Team SmackDown LIVE" ->
              Map.put(acc, :tag_team_found, true)

            text ->
              Map.put(acc, :new_array, acc.new_array ++ [text])
          end
        end
      end
    )
    |> Map.get(:new_array)
  end

  # credo:disable-for-lines:19
  def remove_things_between_brackets(array) do
    array
    |> Enum.reduce(%{brackets: 0, new_array: []}, fn x, acc ->
      cond do
        is_tuple(x) ->
          if acc.brackets == 0 do
            Map.put(acc, :new_array, acc.new_array ++ [x])
          else
            acc
          end

        String.match?(x, ~r/[\(\[\{]/) ->
          Map.put(acc, :brackets, acc.brackets + 1)

        String.match?(x, ~r/[\)\]\}]/) ->
          Map.put(acc, :brackets, acc.brackets - 1)

        true ->
          if acc.brackets == 0 do
            Map.put(acc, :new_array, acc.new_array ++ [x])
          else
            acc
          end
      end
    end)
    |> Map.get(:new_array)
  end

  def split_by_outcome_and_team(result) do
    case result
         |> Enum.chunk_by(fn x ->
           is_bitstring(x) && String.contains?(x, "defeat")
         end) do
      [winners, _, losers] ->
        winners =
          winners
          |> split_participants_into_teams("and")

        losers =
          losers
          |> split_participants_into_teams("and", length(winners))

        [{winners, "win"}, {losers, "loss"}]

      [drawers] ->
        drawers =
          drawers
          |> split_participants_into_teams("vs.")

        [{drawers, "draw"}]

      _ ->
        Logger.error("Unexpeced match outcome")

        []
    end
  end

  @spec split_participants_into_teams(
          participants :: [],
          split_by :: String.t(),
          offset :: integer
        ) :: []
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

  # credo:disable-for-lines:32
  @spec convert_participant_info({participants :: [], outcome :: String.t()}) ::
          [[]]
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

          jobber_name ->
            if(
              is_bitstring(jobber_name) &&
                !String.match?(jobber_name, ~r/^[&,-]/)
            ) do
              %{
                alias: jobber_name,
                profile_url: nil,
                outcome: outcome,
                match_team: match_team
              }
            end
        end
      end)
    end)
  end

  @spec get_and_add_alias_id(participant_info :: map) :: map
  defp get_and_add_alias_id(participant_info) do
    alias_id = Aliases.get_alias_id(participant_info.alias)

    alias_id =
      case alias_id do
        nil ->
          Wrestlers.save_alter_egos_of_wrestler(%{
            wrestler_url_path: participant_info.profile_url,
            alias: participant_info.alias
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

  @spec save_participant_to_database(participant_info :: map) :: integer
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
