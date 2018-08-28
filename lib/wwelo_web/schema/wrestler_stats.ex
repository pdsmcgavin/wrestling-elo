defmodule WweloWeb.Schema.WrestlerStats do
  @moduledoc false
  use Absinthe.Schema.Notation

  alias Wwelo.Stats

  object :wrestler_stats do
    field(:wrestler_stat, list_of(:wrestler_stat))
  end

  object :current_wrestler_stats do
    field(:current_wrestler_stat, list_of(:wrestler_stat))
  end

  object :wrestler_stat do
    field(:id, :integer)
    field(:name, :string)
    field(:aliases, list_of(:string))
    field(:gender, :string)
    field(:height, :integer)
    field(:weight, :integer)
    field(:current_elo, :elo)
    field(:max_elo, :elo)
    field(:min_elo, :elo)
    field(:brand, :string)
  end

  object :wrestler_elo_histories do
    field(:wrestler_elo_history, list_of(:wrestler_elo_history))
  end

  object :wrestler_elo_history do
    field(:id, :integer)
    field(:elos, list_of(:elo))
  end

  object :elo do
    field(:elo, :float)
    field(:date, :string)
  end

  object :wrestler_stat_queries do
    field :wrestler_stats, :wrestler_stats do
      arg(:min_matches, :integer)

      resolve(fn %{min_matches: min_matches}, _ ->
        {:ok, %{wrestler_stat: Stats.list_wrestlers_stats(min_matches)}}
      end)
    end

    field :current_wrestler_stats, :current_wrestler_stats do
      arg(:min_matches, :integer)
      arg(:last_match_within_days, :integer)
      arg(:date, :date)

      resolve(fn %{
                   min_matches: min_matches,
                   last_match_within_days: last_match_within_days,
                   date: date
                 },
                 _ ->
        {:ok,
         %{
           current_wrestler_stat:
             Stats.list_current_wrestlers_stats(
               min_matches,
               last_match_within_days,
               date
             )
         }}
      end)
    end

    field :wrestler_elo_histories, :wrestler_elo_histories do
      arg(:ids, list_of(:integer))

      resolve(fn %{ids: ids}, _ ->
        {:ok,
         %{
           wrestler_elo_history:
             Enum.map(ids, fn id ->
               Stats.wrestler_elos_by_id(id)
             end)
         }}
      end)
    end
  end
end
