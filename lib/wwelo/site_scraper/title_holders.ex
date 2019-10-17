defmodule Wwelo.SiteScraper.TitleHolders do
  @moduledoc false

  require Logger

  alias Wwelo.Repo
  alias Wwelo.SiteScraper.Aliases
  alias Wwelo.SiteScraper.Utils.UrlHelper
  alias Wwelo.Stats
  alias Wwelo.Stats.TitleHolder

  @spec save_current_title_holders_to_database :: :ok
  def save_current_title_holders_to_database do
    Logger.warn("Updating title holders")

    title_holders = get_active_title_holders_list()
    Repo.delete_all(TitleHolder)

    Enum.each(title_holders, fn member ->
      save_title_holder_to_database(member)
    end)
  end

  @spec get_active_title_holders_list :: [map]
  def get_active_title_holders_list do
    title_contents =
      title_holder_html_body()
      |> Floki.find(".TableContents")

    all_titles_table =
      case title_contents do
        [{_, _, [{_, _, [_ | titles]}]}] ->
          titles

        _ ->
          Logger.error("No title holders found")
          []
      end

    all_titles_table =
      all_titles_table
      |> Enum.map(fn title_info ->
        {_, _,
         [
           _,
           {_, _, [{_, _, [name]}]},
           {_, _, holder_info},
           _,
           _,
           _
         ]} = title_info

        %{name: name, holder_info: holder_info}
      end)

    current_titles()
    |> Enum.map(fn title ->
      title_holder_info =
        all_titles_table
        |> Enum.find(fn potential_title ->
          potential_title.name == title.name_to_match
        end)

      if is_nil(title_holder_info) do
        Map.put(title, :alias_id, nil)
      else
        title_holder_name =
          case title_holder_info |> Map.get(:holder_info) do
            [{_, _, [holder_name]}] -> holder_name
            [{_, _, [holder_name]}, _] -> holder_name
            _ -> nil
          end

        if is_nil(title_holder_name) do
          Map.put(title, :alias_id, nil)
        else
          title_holder_alias_id = title_holder_name |> Aliases.get_alias_id()

          Map.put(title, :alias_id, title_holder_alias_id)
        end
      end
    end)
  end

  @spec title_holder_html_body :: String.t()
  defp title_holder_html_body do
    UrlHelper.get_page_html_body("https://www.cagematch.net/?id=8&nr=1&page=9")
  end

  defp save_title_holder_to_database(%{
         brand: brand,
         gender: gender,
         alias_id: holder_alias_id,
         name: name
       }) do
    Stats.create_title_holder(%{
      brand: brand,
      gender: gender,
      holder_alias_id: holder_alias_id,
      name: name
    })
  end

  def current_titles() do
    [
      %{
        name_to_match: "WWE Championship",
        gender: :male,
        brand: "SmackDown",
        name: "WWE Championship"
      },
      %{
        name_to_match: "WWE Cruiserweight  Championship",
        gender: :male,
        brand: "205 Live",
        name: "Cruiserweight Championship"
      },
      %{
        name_to_match: "WWE NXT Championship",
        gender: :male,
        brand: "NXT",
        name: "NXT Championship"
      },
      %{
        name_to_match: "WWE NXT Women's Championship",
        gender: :female,
        brand: "NXT",
        name: "NXT Women's Championship"
      },
      %{
        name_to_match: "WWE RAW Women's Championship",
        gender: :female,
        brand: "RAW",
        name: "RAW Women's Championship"
      },
      %{
        name_to_match: "WWE SmackDown Women's Championship",
        gender: :female,
        brand: "SmackDown",
        name: "SmackDown Women's Championship"
      },
      %{
        name_to_match: "WWE Universal Championship",
        gender: :male,
        brand: "RAW",
        name: "Universal Championship"
      }
    ]
  end
end
