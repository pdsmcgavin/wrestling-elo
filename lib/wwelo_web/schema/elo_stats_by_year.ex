defmodule WweloWeb.Schema.EloStatsByYear do
  @moduledoc false
  use Absinthe.Schema.Notation

  alias Wwelo.StatsCache

  object :elo_stats_of_year do
    field(:year, :integer)
    field(:max_elo, :elo_info)
    field(:min_elo, :elo_info)
    field(:max_elo_difference, :elo_difference_info)
    field(:min_elo_difference, :elo_difference_info)
  end

  object :elo_info do
    field(:elo, :float)
    field(:name, :string)
  end

  object :elo_difference_info do
    field(:elo_difference, :float)
    field(:name, :string)
  end

  object :elo_stats_by_year_queries do
    field :elo_stats_by_year, list_of(:elo_stats_of_year) do
      resolve(fn _, _ ->
        {:ok, StatsCache.get_elo_stats_by_year()}
      end)
    end
  end
end
