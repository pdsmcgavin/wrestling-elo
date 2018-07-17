defmodule WweloWeb.Schema do
  @moduledoc false
  use Absinthe.Schema

  import_types(WweloWeb.Schema.EloStatsByYear)
  import_types(WweloWeb.Schema.WrestlerStats)

  query do
    import_fields(:wrestler_stat_queries)
    import_fields(:elo_stats_by_year_queries)
  end
end
