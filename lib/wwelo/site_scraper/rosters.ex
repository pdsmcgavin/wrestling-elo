defmodule Wwelo.SiteScraper.Rosters do
  @moduledoc false

  alias Wwelo.Repo
  alias Wwelo.SiteScraper.Utils.UrlHelper
  alias Wwelo.Stats.Alias
  alias Wwelo.Stats.Wrestler

  def roster_html_body do
    UrlHelper.get_page_html_body(%{
      url: "https://www.cagematch.net/?id=8&nr=1&page=15"
    })
  end

  def get_entire_roster_list do
    [{_, _, [{_, _, [_ | entire_roster]}]}] =
      roster_html_body()
      |> Floki.find(".TableContents")

    Enum.reduce(entire_roster, [], fn worker, acc ->
      {_, _,
       [
         _,
         _,
         {_, _, [{_, _, [wrestler]}]},
         {_, _, jobs},
         {_, _, brand},
         _,
         _
       ]} = worker

      case active_roster_member?(jobs, brand) do
        true -> acc ++ [%{wrestler: wrestler, brand: brand}]
        _ -> acc
      end
    end)
  end

  def is_wrestler_active?(name) do
    wrestler_id = Alias |> Repo.get_by(name: name) |> Map.get(:wrestler_id)

    if is_nil(wrestler_id) do
      Wrestler
      |> Repo.get(wrestler_id)
      |> Map.get(:career_end_date)
      |> is_nil
    else
      false
    end
  end

  def active_roster_member?(jobs, brand) do
    !Enum.any?(brand, fn x -> x == "Legend" end) &&
      Enum.any?(jobs, fn x -> String.contains?(x, "Wrestler") end) &&
      Enum.any?(jobs, fn x -> !String.contains?(x, "Road Agent") end)
  end
end
