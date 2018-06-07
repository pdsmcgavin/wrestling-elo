defmodule WweloWeb.Schema do
  @moduledoc false
  use Absinthe.Schema

  alias Wwelo.Repo
  alias Wwelo.Stats
  alias Wwelo.Stats.Wrestler

  object :wrestler do
    field(:id, :integer)
    field(:name, :string)
  end

  object :wrestler_elos do
    field(:wrestler_elo, list_of(:wrestler_elo))
  end

  object :wrestler_elo do
    field(:name, :string)
    field(:current_elo, :elo)
    field(:max_elo, :elo)
    field(:min_elo, :elo)
  end

  object :elo do
    field(:elo, :float)
    field(:date, :string)
  end

  query do
    field :wrestler, :wrestler do
      arg(:id, non_null(:id))

      resolve(fn %{id: wrestler_id}, _ ->
        %{name: wrestler_name} = Repo.get(Wrestler, wrestler_id)

        {:ok, %{id: wrestler_id, name: wrestler_name}}
      end)
    end

    field :wrestler_elos, :wrestler_elos do
      arg(:min_matches, :integer)

      resolve(fn %{min_matches: min_matches}, _ ->
        {:ok, %{wrestler_elo: Stats.list_wrestlers_elos(min_matches)}}
      end)
    end
  end
end
