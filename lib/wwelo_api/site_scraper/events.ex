defmodule WweloApi.SiteScraper.Events do
  import Ecto.Query

  alias WweloApi.Repo
  alias WweloApi.Stats
  alias WweloApi.Stats.Event
  alias WweloApi.SiteScraper.Utils.DateHelper
  alias WweloApi.SiteScraper.Utils.UrlHelper

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

  def get_event_info(%{event_url_path: event_url_path}) do
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

  def convert_event_info(event_info) do
    Enum.reduce(event_info, %{}, fn x, acc ->
      convert_event_info(x, acc)
    end)
  end

  # TODO: Move all convert event info stuff to a separate module utils/EventConverterHelper.ex?
  def convert_event_info(
        {_, _, [{_, _, ["Name of the event:"]}, {_, _, [event_name]}]},
        acc
      ) do
    Map.put(acc, :name, event_name)
  end

  def convert_event_info(
        {_, _, [{_, _, ["Promotion:"]}, {_, _, [{_, _, [promotion]}]}]},
        acc
      ) do
    Map.put(acc, :promotion, promotion)
  end

  def convert_event_info(
        {_, _, [{_, _, ["Type:"]}, {_, _, [event_type]}]},
        acc
      ) do
    Map.put(acc, :event_type, event_type)
  end

  def convert_event_info(
        {_, _, [{_, _, ["Location:"]}, {_, _, [location]}]},
        acc
      ) do
    Map.put(acc, :location, location)
  end

  def convert_event_info(
        {_, _, [{_, _, ["Arena:"]}, {_, _, [arena]}]},
        acc
      ) do
    Map.put(acc, :arena, arena)
  end

  def convert_event_info(
        {_, _, [{_, _, ["Date:"]}, {_, _, [date]}]},
        acc
      ) do
    case DateHelper.format_date(date) do
      {:ok, date} -> Map.put_new(acc, :date, date)
      _ -> acc
    end
  end

  def convert_event_info(
        {_, _, [{_, _, ["Broadcast date:"]}, {_, _, [date]}]},
        acc
      ) do
    case DateHelper.format_date(date) do
      {:ok, date} -> Map.put(acc, :date, date)
      _ -> acc
    end
  end

  def convert_event_info(_, acc) do
    acc
  end

  def save_event_to_database(event_info) do
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
