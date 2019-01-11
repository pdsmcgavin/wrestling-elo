defmodule WweloWeb.Schema.TitleHolders do
  @moduledoc false
  use Absinthe.Schema.Notation

  alias Wwelo.Stats

  object :title_holder do
    field(:name, :string)
    field(:belt_name, :string)
    field(:brand, :string)
    field(:gender, :string)
  end

  object :title_holders_queries do
    field :title_holders, list_of(:title_holder) do
      resolve(fn _, _ ->
        {:ok, Stats.get_title_holders()}
      end)
    end
  end
end
