defmodule WweloWeb.Schema do
  @moduledoc false
  use Absinthe.Schema

  import_types(WweloWeb.Schema.EloStatsByYear)
  import_types(WweloWeb.Schema.WrestlerStats)
  import_types(WweloWeb.Schema.TitleHolders)
  import_types(Absinthe.Type.Custom)

  query do
    import_fields(:wrestler_stat_queries)
    import_fields(:elo_stats_by_year_queries)
    import_fields(:title_holders_queries)
  end
end
