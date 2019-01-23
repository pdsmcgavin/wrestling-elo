defmodule Wwelo.SiteScraper.Matches do
  @moduledoc false

  require Logger

  import Ecto.Query

  alias Wwelo.Repo
  alias Wwelo.Stats
  alias Wwelo.Stats.Match

  @spec save_matches_of_event(map) :: [map]
  def save_matches_of_event(%{event_id: event_id, event_matches: matches}) do
    matches
    |> filter_out_non_televised_matches
    |> Enum.with_index(1)
    |> Enum.map(fn {match, card_position} ->
      match_id =
        event_id
        |> convert_match_info(match, card_position)
        |> save_match_to_database

      [{_, _, match_result}] = Floki.find(match, ".MatchResults")
      %{match_id: match_id, match_result: match_result}
    end)
  end

  @spec convert_match_info(
          event_id :: integer,
          match :: String.t(),
          card_position :: integer
        ) :: map
  defp convert_match_info(event_id, match, card_position) do
    %{event_id: event_id, card_position: card_position}
    |> Map.put(:stipulation, get_match_stipulation(match))
  end

  @spec save_match_to_database(match_info :: map) :: integer
  defp save_match_to_database(match_info) do
    match_query =
      from(
        m in Match,
        where:
          m.event_id == ^match_info.event_id and
            m.card_position == ^match_info.card_position,
        select: m
      )

    match_result = Repo.one(match_query)

    match_result =
      if is_nil(match_result) do
        match_info |> Stats.create_match() |> elem(1)
      else
        match_result
      end

    match_result |> Map.get(:id)
  end

  @spec filter_out_non_televised_matches(matches :: []) :: []
  defp filter_out_non_televised_matches(matches) do
    Enum.filter(matches, fn match ->
      case match do
        {_, [{"class", "Match"}], _} ->
          true

        {_, [{"class", "Dark Match"}], _} ->
          false

        _ ->
          Logger.error("Match edge case: " <> Poison.encode!(match))
          false
      end
    end)
  end

  @spec get_match_stipulation(match :: String.t()) :: String.t()
  defp get_match_stipulation(match) do
    match_type = match |> Floki.find(".MatchType")

    case match_type do
      [{_, [{"class", "MatchType"}], stipulation}] ->
        stipulation |> combine_stipulation_info

      _ ->
        # Checking for edge cases
        Logger.error("Match type edge case: " <> Poison.encode!(match))
        "No stipulation found"
    end
  end

  @spec combine_stipulation_info(stipulation :: []) :: String.t()
  defp combine_stipulation_info(stipulation) do
    stipulation
    |> Enum.reduce("", fn x, acc ->
      case x do
        {_, _, [title]} -> acc <> title
        string -> acc <> string
      end
    end)
  end
end
