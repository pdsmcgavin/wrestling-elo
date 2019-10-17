defmodule Wwelo.StatsCache do
  @moduledoc """
    Same interface as Wwelo.Stats but with a pass through cache using cachex
  """
  alias Wwelo.Stats

  def cache_important_queries do
    get_elo_stats_by_year()
    get_title_holders()
    list_wrestlers_stats(50)

    list_current_wrestlers_stats(
      10,
      365,
      Date.utc_today() |> Date.to_string()
    )

    list_current_wrestlers_stats(
      10,
      365,
      Date.utc_today() |> Date.add(1) |> Date.to_string()
    )

    list_current_wrestlers_stats(
      10,
      365,
      Date.utc_today() |> Date.add(-7) |> Date.to_string()
    )

    list_current_wrestlers_stats(
      10,
      365,
      Date.utc_today() |> Date.add(6) |> Date.to_string()
    )
  end

  def get_brands do
    key = "get_brands"

    Cachex.get(:wwelo_cache, key)
    |> retrieve(key, &Stats.get_brands/0, [])
  end

  def get_elo_stats_by_year do
    key = "get_elo_stats_by_year"

    Cachex.get(:wwelo_cache, key)
    |> retrieve(key, &Stats.get_elo_stats_by_year/0, [])
  end

  def get_events(event_type) do
    key = "get_events-#{event_type}"

    Cachex.get(:wwelo_cache, key)
    |> retrieve(key, &Stats.get_events/1, [event_type])
  end

  def get_upcoming_events(event_type) do
    key = "get_upcoming_events-#{event_type}"

    Cachex.get(:wwelo_cache, key)
    |> retrieve(key, &Stats.get_upcoming_events/1, [event_type])
  end

  def get_event(event_id) do
    key = "get_event-#{event_id}"

    Cachex.get(:wwelo_cache, key)
    |> retrieve(key, &Stats.get_event/1, [event_id])
  end

  def get_title_holders do
    key = "get_title_holders"

    Cachex.get(:wwelo_cache, key)
    |> retrieve(key, &Stats.get_title_holders/0, [])
  end

  def list_current_wrestlers_stats(min_matches, last_match_within_days, date) do
    key =
      "list_current_wrestlers_stats-#{min_matches}-#{last_match_within_days}-#{
        date
      }"

    Cachex.get(:wwelo_cache, key)
    |> retrieve(key, &Stats.list_current_wrestlers_stats/3, [
      min_matches,
      last_match_within_days,
      date
    ])
  end

  def list_wrestlers_stats(min_matches) do
    key = "list_wrestlers_stats-#{min_matches}"

    Cachex.get(:wwelo_cache, key)
    |> retrieve(key, &Stats.list_wrestlers_stats/1, [min_matches])
  end

  def wrestler_elos_by_id(wrestler_id) do
    key = "wrestler_elos_by_id-#{wrestler_id}"

    Cachex.get(:wwelo_cache, key)
    |> retrieve(key, &Stats.wrestler_elos_by_id/1, [wrestler_id])
  end

  defp retrieve({:ok, nil}, key, value_fn, fn_params) do
    value = apply(value_fn, fn_params)

    Cachex.put(:wwelo_cache, key, value)

    value
  end

  defp retrieve({:ok, value}, _, _, _), do: value
end
