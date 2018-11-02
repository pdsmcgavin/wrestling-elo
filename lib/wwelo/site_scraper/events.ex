defmodule Wwelo.SiteScraper.Events do
  @moduledoc false

  import Ecto.Query

  alias Wwelo.Repo
  alias Wwelo.Stats
  alias Wwelo.Stats.Event
  alias Wwelo.SiteScraper.Utils.EventInfoConverterHelper
  alias Wwelo.SiteScraper.Utils.UrlHelper

  @spec save_events_of_year(year :: integer) :: [map]
  def save_events_of_year(year) do
    # credo:disable-for-next-line
    IO.inspect(year)

    list_of_event_urls = UrlHelper.wwe_event_url_paths_list(year)

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

  @spec get_event_info(event_url_path :: String.t()) :: map
  defp get_event_info(event_url_path) do
    event_url = "https://www.cagematch.net/" <> event_url_path
    event_html_body = UrlHelper.get_page_html_body(event_url)

    [{_, _, event_info}] =
      event_html_body
      |> Floki.find(".InformationBoxTable")

    event_matches =
      case event_html_body |> Floki.find(".Matches") do
        [{_, _, event_matches}] -> event_matches
        _ -> []
      end

    %{event_info: event_info, event_matches: event_matches}
  end

  @spec convert_event_info(event_info :: [{}]) :: map
  defp convert_event_info(event_info) do
    Enum.reduce(event_info, %{}, fn x, acc ->
      EventInfoConverterHelper.convert_event_info(x, acc)
    end)
  end

  @spec save_event_to_database(event_info :: map) :: integer
  defp save_event_to_database(event_info) do
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
end
