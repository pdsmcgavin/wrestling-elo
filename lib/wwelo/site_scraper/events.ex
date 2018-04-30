defmodule Wwelo.SiteScraper.Events do
  @moduledoc false

  import Ecto.Query

  alias Wwelo.Repo
  alias Wwelo.Stats
  alias Wwelo.Stats.Event
  alias Wwelo.SiteScraper.Utils.EventInfoConverterHelper
  alias Wwelo.SiteScraper.Utils.UrlHelper

  def save_events_of_year(%{year: year}) do
    # credo:disable-for-next-line
    IO.inspect(year)

    list_of_event_urls = UrlHelper.wwe_event_url_paths_list(%{year: year})

    list_of_event_urls
    |> Enum.map(fn url_path ->
      %{event_info: event_info, event_matches: event_matches} =
        get_event_info(%{event_url_path: url_path})

      event_id =
        event_info
        |> convert_event_info
        |> save_event_to_database

      %{event_id: event_id, event_matches: event_matches}
    end)
  end

  defp get_event_info(%{event_url_path: event_url_path}) do
    event_url = "https://www.cagematch.net/" <> event_url_path
    event_html_body = UrlHelper.get_page_html_body(%{url: event_url})

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

  defp convert_event_info(event_info) do
    Enum.reduce(event_info, %{}, fn x, acc ->
      EventInfoConverterHelper.convert_event_info(x, acc)
    end)
  end

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
      case event_result do
        nil -> event_info |> Stats.create_event() |> elem(1)
        _ -> event_result
      end

    event_result |> Map.get(:id)
  end
end
