defmodule Wwelo.SiteScraper.Wrestlers do
  import Ecto.Query

  alias Wwelo.Repo
  alias Wwelo.Stats
  alias Wwelo.Stats.Wrestler
  alias Wwelo.SiteScraper.Aliases
  alias Wwelo.SiteScraper.Utils.WrestlerInfoConverterHelper
  alias Wwelo.SiteScraper.Utils.UrlHelper

  def save_alter_egos_of_wrestler(%{wrestler_url_path: wrestler_url_path}) do
    wrestler_info =
      wrestler_url_path
      |> get_wrestler_info

    wrestler_info =
      case wrestler_info do
        [] -> empty_wrestler_profile_info(wrestler_url_path)
        _ -> wrestler_info |> convert_wrestler_info
      end

    wrestler_ids =
      Enum.map(Map.keys(wrestler_info.names), fn name ->
        wrestler_info
        |> Map.put(:name, name |> Atom.to_string())
        |> save_wrestler_to_database()
      end)

    wrestler_ids
    |> Enum.zip(wrestler_info.names |> Map.values())
    |> Enum.map(fn {wrestler_id, aliases} ->
      %{wrestler_id: wrestler_id, aliases: aliases}
      |> Aliases.save_aliases_to_database()
    end)
  end

  def get_wrestler_info(wrestler_url_path) do
    wrestler_url = "https://www.cagematch.net/" <> wrestler_url_path

    %{url: wrestler_url}
    |> UrlHelper.get_page_html_body()
    |> Floki.find(".InformationBoxRow")
  end

  def convert_wrestler_info(wrestler_info) do
    Enum.reduce(wrestler_info, %{}, fn x, acc ->
      WrestlerInfoConverterHelper.convert_wrestler_info(x, acc)
    end)
  end

  def empty_wrestler_profile_info(wrestler_url_path) do
    name =
      wrestler_url_path
      |> String.split("name=")
      |> Enum.at(1)
      |> String.replace("+", " ")

    Map.put(%{}, :names, %{} |> Map.put(String.to_atom(name), [name]))
  end

  def save_wrestler_to_database(wrestler_info) do
    wrestler_query =
      from(
        w in Wrestler,
        where: w.name == ^wrestler_info.name,
        select: w
      )

    wrestler_result = Repo.one(wrestler_query)

    wrestler_result =
      case wrestler_result do
        nil -> wrestler_info |> Stats.create_wrestler() |> elem(1)
        _ -> wrestler_result
      end

    wrestler_result |> Map.get(:id)
  end
end
