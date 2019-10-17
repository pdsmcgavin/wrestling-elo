defmodule Wwelo.SiteScraper.Rosters do
  @moduledoc false

  require Logger

  alias Wwelo.Repo
  alias Wwelo.SiteScraper.Utils.UrlHelper
  alias Wwelo.Stats
  alias Wwelo.Stats.Alias
  alias Wwelo.Stats.Roster
  alias Wwelo.Stats.Wrestler

  @spec save_current_roster_to_database :: :ok
  def save_current_roster_to_database do
    Logger.warn("Updating roster")

    roster = get_active_roster_list()
    Repo.delete_all(Roster)

    Enum.each(roster, fn member -> save_roster_member_to_database(member) end)
  end

  @spec get_active_roster_list :: [map]
  defp get_active_roster_list do
    roster_contents = roster_html_body() |> Floki.find(".TableContents")

    entire_roster =
      case roster_contents do
        [{_, _, [{_, _, [_ | roster]}]}] ->
          roster

        _ ->
          Logger.error("No roster found")
          []
      end

    Enum.reduce(entire_roster, [], fn worker, acc ->
      {_, _,
       [
         _,
         _,
         {_, _, [{_, _, [wrestler]}]},
         _,
         {_, _, brands},
         _,
         _
       ]} = worker

      trimmed_wrestler = wrestler |> String.trim()

      wrestler_id = Alias |> Repo.get_by(name: trimmed_wrestler) |> Map.get(:id)

      case is_wrestler_active?(wrestler_id, brands) do
        true ->
          acc ++
            [
              %{
                wrestler_id: wrestler_id,
                brand: brands,
                alias: trimmed_wrestler
              }
            ]

        _ ->
          acc
      end
    end)
  end

  @spec roster_html_body :: String.t()
  defp roster_html_body do
    UrlHelper.get_page_html_body("https://www.cagematch.net/?id=8&nr=1&page=15")
  end

  @spec is_wrestler_active?(wrestler_id :: map | nil, []) :: boolean
  defp is_wrestler_active?(nil, _) do
    false
  end

  defp is_wrestler_active?(wrestler_id, brands) do
    !Enum.any?(brands, &(&1 == 'Legend')) &&
      Wrestler
      |> Repo.get(wrestler_id)
      |> Map.get(:career_end_date)
      |> is_nil
  end

  @spec save_roster_member_to_database(map) :: :ok
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
