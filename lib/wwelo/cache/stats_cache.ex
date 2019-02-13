defmodule Wwelo.StatsCache do
  @moduledoc """
    Same interface as Wwelo.Stats but with a pass through cache using cachex
  """
  alias Wwelo.Stats

  def list_wrestlers_stats(min_matches) do
    key = "list_wrestlers_stats-#{min_matches}"

    Cachex.get(:wwelo_cache, key)
    |> retrieve(key, &Stats.list_wrestlers_stats/1, [min_matches])
  end

  defp retrieve({:ok, nil}, key, value_fn, fn_params) do
    value = apply(value_fn, fn_params)

    Cachex.put(:wwelo_cache, key, value)

    value
  end

  defp retrieve({:ok, value}, _, _, _), do: value
end
