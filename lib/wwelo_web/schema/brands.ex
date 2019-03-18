defmodule WweloWeb.Schema.Brands do
  @moduledoc false
  use Absinthe.Schema.Notation

  alias Wwelo.StatsCache

  object :brand do
    field(:name, :string)
  end

  object :brands_queries do
    field :brands, list_of(:brand) do
      resolve(fn _, _ ->
        {:ok, StatsCache.get_brands()}
      end)
    end
  end
end
