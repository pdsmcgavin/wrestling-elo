defmodule WweloApi.SiteScraper.Aliases do
  import Ecto.Query

  alias WweloApi.Repo
  alias WweloApi.Stats
  alias WweloApi.Stats.Alias

  def save_aliases_to_database(aliases_info) do
    aliases_info
    |> Map.get(:aliases)
    |> Enum.map(fn alias ->
      Map.put(aliases_info, :name, alias)
      |> save_alias_to_database
    end)
  end

  def save_alias_to_database(alias_info) do
    alias_query =
      from(
        a in Alias,
        where: a.name == ^alias_info.name,
        select: a
      )

    alias_result = Repo.one(alias_query)

    case alias_result do
      nil -> Stats.create_alias(alias_info) |> elem(1)
      _ -> alias_result
    end
    |> Map.get(:id)
  end
end
