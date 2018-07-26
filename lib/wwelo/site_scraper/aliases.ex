defmodule Wwelo.SiteScraper.Aliases do
  @moduledoc false

  import Ecto.Query

  alias Wwelo.Repo
  alias Wwelo.Stats
  alias Wwelo.Stats.Alias

  @spec get_alias_id(name :: String.t()) :: integer | nil
  def get_alias_id(name) do
    alias_query =
      from(
        a in Alias,
        where: a.name == ^name,
        select: a
      )

    alias_result = Repo.one(alias_query)

    case alias_result do
      nil -> nil
      _ -> alias_result |> Map.get(:id)
    end
  end

  @spec save_aliases_to_database(aliases_info :: map) :: [integer]
  def save_aliases_to_database(aliases_info) do
    aliases_info
    |> Map.get(:aliases)
    |> Enum.map(fn alias ->
      aliases_info
      |> Map.put(:name, alias)
      |> save_alias_to_database
    end)
  end

  @spec save_alias_to_database(alias_info :: map) :: integer
  defp save_alias_to_database(alias_info) do
    alias_query =
      from(
        a in Alias,
        where: a.name == ^alias_info.name,
        select: a
      )

    alias_result = Repo.one(alias_query)

    alias_result =
      case alias_result do
        nil -> alias_info |> Stats.create_alias() |> elem(1)
        _ -> alias_result
      end

    alias_result |> Map.get(:id)
  end
end
