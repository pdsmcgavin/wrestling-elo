defmodule WweloWeb.Schema.TitleHolders do
  @moduledoc false
  use Absinthe.Schema.Notation

  alias Wwelo.Stats

  object :title_holders do
    field(:title_holders, list_of(:title_holder))
  end

  object :title_holder do
    field(:name, :string)
    field(:belt_name, :string)
    field(:brand, :string)
    field(:gender, :string)
  end

  object :title_holders_queries do
    field :title_holders, :title_holders do
      resolve(fn _, _ ->
        {:ok, %{elo_stats_of_year: Stats.get_title_holders()}}
      end)
    end
  end
end
