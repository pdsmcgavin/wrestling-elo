defmodule WweloWeb.Schema do
  @moduledoc false
  use Absinthe.Schema

  alias Wwelo.Stats

  object :wrestler_stats do
    field(:wrestler_stat, list_of(:wrestler_stat))
  end

  object :current_wrestler_stats do
    field(:current_wrestler_stat, list_of(:wrestler_stat))
  end

  object :wrestler_stat do
    field(:name, :string)
    field(:current_elo, :elo)
    field(:height, :integer)
    field(:max_elo, :elo)
    field(:min_elo, :elo)
    field(:brand, :string)
  end

  object :elo do
    field(:elo, :float)
    field(:date, :string)
  end

  query do
    field :wrestler_stats, :wrestler_stats do
      arg(:min_matches, :integer)

      resolve(fn %{min_matches: min_matches}, _ ->
        {:ok, %{wrestler_stat: Stats.list_wrestlers_stats(min_matches)}}
      end)
    end

    field :current_wrestler_stats, :current_wrestler_stats do
      arg(:min_matches, :integer)

      resolve(fn %{min_matches: min_matches}, _ ->
        {:ok,
         %{
           current_wrestler_stat:
             Stats.list_current_wrestlers_stats(min_matches)
         }}
      end)
    end
  end
end
