defmodule WweloApi.SiteScraper.Matches do
  import Ecto.Query

  alias WweloApi.Repo
  alias WweloApi.Stats
  alias WweloApi.Stats.Match

  def save_matches_of_event(%{event_id: event_id, event_matches: matches}) do
    matches
    |> filter_out_non_televised_matches
    |> Enum.with_index(1)
    |> Enum.map(fn {match, card_position} ->
      match_id =
        convert_match_info(event_id, match, card_position)
        |> save_match_to_database

      [{_, _, match_result}] = Floki.find(match, ".MatchResults")
      %{match_id: match_id, match_result: match_result}
    end)
  end

  def convert_match_info(event_id, match, card_position) do
    %{event_id: event_id, card_position: card_position}
    |> Map.put(:stipulation, get_match_stipulation(match))
  end

  def save_match_to_database(match_info) do
    match_query =
      from(
        m in Match,
        where:
          m.event_id == ^match_info.event_id and
            m.card_position == ^match_info.card_position,
        select: m
      )

    match_result = Repo.one(match_query)

    case match_result do
      nil -> Stats.create_match(match_info) |> elem(1)
      _ -> match_result
    end
    |> Map.get(:id)
  end

  def filter_out_non_televised_matches(matches) do
    Enum.filter(matches, fn match ->
      case match do
        {_, [{"class", "Match"}], _} ->
          true

        {_, [{"class", "Dark Match"}], _} ->
          false

        _ ->
          # Checking for edge cases
          IO.puts("Match edge case")
          IO.inspect(match)
          false
      end
    end)
  end

  def get_match_stipulation(match) do
    match_type = match |> Floki.find(".MatchType")

    case match_type do
      [{_, [{"class", "MatchType"}], stipulation}] ->
        stipulation |> combine_stipulation_info

      _ ->
        # Checking for edge cases
        IO.puts("Match type edge case")
        IO.inspect(match)
        "No stipulation found"
    end
  end

  def combine_stipulation_info(stipulation) when is_bitstring(stipulation),
    do: stipulation |> IO.inspect()

  def combine_stipulation_info(stipulation) do
    stipulation
    |> Enum.reduce("", fn x, acc ->
      case x do
        {_, _, [title]} -> acc <> title
        string -> acc <> string
      end
    end)
  end
end
