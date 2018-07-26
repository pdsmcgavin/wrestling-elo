defmodule Wwelo.SiteScraper.Rosters do
  @moduledoc false

  alias Wwelo.Repo
  alias Wwelo.SiteScraper.Utils.UrlHelper
  alias Wwelo.Stats
  alias Wwelo.Stats.Alias
  alias Wwelo.Stats.Roster
  alias Wwelo.Stats.Wrestler

  def save_current_roster_to_database do
    roster = get_active_roster_list()
    Repo.delete_all(Roster)
    Enum.each(roster, fn member -> save_roster_member_to_database(member) end)
  end

  defp get_active_roster_list do
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

      wrestler_id = get_active_wrestler_id(wrestler)

      case wrestler?(jobs, brand) && !is_nil(wrestler_id) do
        true ->
          acc ++ [%{wrestler_id: wrestler_id, brand: brand, alias: wrestler}]

        _ ->
          acc
      end
    end)
  end

  defp roster_html_body do
    UrlHelper.get_page_html_body("https://www.cagematch.net/?id=8&nr=1&page=15")
  end

  defp wrestler?(jobs, brand) do
    !Enum.any?(brand, fn x -> x == "Legend" end) &&
      Enum.any?(jobs, fn x -> String.contains?(x, "Wrestler") end) &&
      Enum.any?(jobs, fn x -> !String.contains?(x, "Road Agent") end)
  end

  defp get_active_wrestler_id(name) do
    wrestler_alias = Alias |> Repo.get_by(name: name)

    if is_wrestler_active?(wrestler_alias) do
      wrestler_alias |> Map.get(:wrestler_id)
    else
      nil
    end
  end

  defp is_wrestler_active?(nil) do
    false
  end

  defp is_wrestler_active?(wrestler_alias) do
    Wrestler
    |> Repo.get(wrestler_alias |> Map.get(:wrestler_id))
    |> Map.get(:career_end_date)
    |> is_nil
  end

  defp save_roster_member_to_database(%{
         alias: alias,
         brand: [],
         wrestler_id: wrestler_id
       }) do
    Stats.create_roster(%{
      alias: alias,
      brand: "Free Agent",
      wrestler_id: wrestler_id
    })
  end

  defp save_roster_member_to_database(%{
         alias: alias,
         brand: brands,
         wrestler_id: wrestler_id
       }) do
    brands
    |> Enum.each(fn brand ->
      Stats.create_roster(%{
        alias: alias,
        brand: brand,
        wrestler_id: wrestler_id
      })
    end)
  end
end
