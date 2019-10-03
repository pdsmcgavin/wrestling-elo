defmodule Wwelo.SiteScraper.Events do
  @moduledoc false

  require Logger

  import Ecto.Query

  alias Wwelo.Repo
  alias Wwelo.Stats
  alias Wwelo.Stats.Event
  alias Wwelo.SiteScraper.Utils.EventInfoConverterHelper
  alias Wwelo.SiteScraper.Utils.UrlHelper

  @spec save_events_of_year(year :: integer) :: [map]
  def save_events_of_year(year) do
    Logger.warn("Scraping year: #{year}")

    list_of_event_urls =
      year
      |> UrlHelper.wwe_event_url_paths_list()
      |> Enum.filter(&(&1 != "?id=1&nr=1982"))

    list_of_event_urls
    |> Enum.map(fn event_url_path ->
      %{event_info: event_info, event_matches: event_matches} =
        get_event_info(event_url_path)

      event_id =
        event_info
        |> convert_event_info
        |> save_event_to_database

      %{event_id: event_id, event_matches: event_matches}
    end)
  end

  def save_upcoming_events do
    Logger.warn("Scraping upcoming events")

    list_of_upcoming_event_urls = UrlHelper.wwe_upcoming_event_url_paths_list()

    list_of_upcoming_event_urls
    |> Enum.map(fn event_url_path ->
      %{event_info: event_info, event_matches: event_matches} =
        get_event_info(event_url_path)

      event_id =
        event_info
        |> convert_event_info
        |> Map.put(:upcoming, true)
        |> save_event_to_database

      %{event_id: event_id, event_matches: event_matches}
    end)
  end

  @spec get_event_info(event_url_path :: String.t()) :: map
  def get_event_info(event_url_path) do
    event_url = "https://www.cagematch.net/" <> event_url_path
    event_html_body = UrlHelper.get_page_html_body(event_url)

    event_info =
      case event_html_body |> Floki.find(".InformationBoxTable") do
        [{_, _, event_info}] ->
          event_info

        _ ->
          Logger.error("Error scraping: #{event_url}")
          []
      end

    event_matches =
      case event_html_body |> Floki.find(".Matches") do
        [{_, _, event_matches}] ->
          event_matches

        _ ->
          Logger.error("Error find matches: #{event_url}")
          []
      end

    %{event_info: event_info, event_matches: event_matches}
  end

  @spec convert_event_info(event_info :: [{}]) :: map
  defp convert_event_info(event_info) do
    Enum.reduce(event_info, %{}, fn x, acc ->
      EventInfoConverterHelper.convert_event_info(x, acc)
    end)
  end

  defp save_event_to_database(
         %{name: _name, date: _date, location: _location, upcoming: true} =
           event_info
       ) do
    event_query =
      from(
        e in Event,
        where:
          e.name == ^event_info.name and e.date == ^event_info.date and
            e.location == ^event_info.location,
        select: e
      )

    event_result = Repo.one(event_query)

    event_result =
      if is_nil(event_result) do
        event_info |> Stats.create_event() |> elem(1)
      else
        event_result
      end

    event_result |> Map.get(:id)
  end

  @spec save_event_to_database(event_info :: map) :: integer
  defp save_event_to_database(
         %{name: _name, date: _date, location: _location} = event_info
       ) do
    event_query =
      from(
        e in Event,
        where:
          e.name == ^event_info.name and e.date == ^event_info.date and
            e.location == ^event_info.location,
        select: e
      )

    event_result = Repo.one(event_query)

    event_result =
      if is_nil(event_result) do
        event_info |> Stats.create_event() |> elem(1)
      else
        event_result
      end

    event_result |> Map.get(:id)
  end

  defp save_event_to_database(%{}) do
    nil
  end

  def clear_upcoming_events do
    query =
      from(e in Event,
        where: e.upcoming == true
      )

    Repo.delete_all(query)
  end
end
