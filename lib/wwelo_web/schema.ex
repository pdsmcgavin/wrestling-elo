defmodule WweloWeb.Schema do
  @moduledoc false
  use Absinthe.Schema

  import_types(Absinthe.Type.Custom)
  import_types(WweloWeb.Schema.Brands)
  import_types(WweloWeb.Schema.EloStatsByYear)
  import_types(WweloWeb.Schema.Events)
  import_types(WweloWeb.Schema.TitleHolders)
  import_types(WweloWeb.Schema.WrestlerStats)

  query do
    import_fields(:elo_stats_by_year_queries)
    import_fields(:brands_queries)
    import_fields(:events_queries)
    import_fields(:title_holders_queries)
    import_fields(:wrestler_stat_queries)
  end
end
