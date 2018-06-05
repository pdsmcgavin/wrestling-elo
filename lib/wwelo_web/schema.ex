defmodule WweloWeb.Schema do
  @moduledoc false
  use Absinthe.Schema

  alias Wwelo.Repo
  alias Wwelo.Stats.Wrestler

  object :wrestler do
    field(:id, :integer)
    field(:name, :string)
  end

  query do
    field :wrestler, :wrestler do
      arg(:id, non_null(:id))

      resolve(fn %{id: wrestler_id}, _ ->
        %{name: wrestler_name} = Repo.get(Wrestler, wrestler_id)

        {:ok, %{id: wrestler_id, name: wrestler_name}}
      end)
    end
  end
end
