defmodule Wwelo.SiteScraper.Utils.UrlHelper do
  @moduledoc false
  alias Wwelo.SiteScraper.EventSearchResults

  @spec get_page_html_body(url :: String.t()) :: String.t()
  def get_page_html_body(url) do
    url
    |> HTTPoison.get!()
    |> Map.get(:body)
    |> cp1252_to_utf8_converter()
  end

  @spec wwe_event_url_paths_list(year :: integer, page_number :: integer) :: [
          String.t()
        ]
  def wwe_event_url_paths_list(year, page_number) do
    results_body = get_page_html_body(wwe_events_results_url(year, page_number))

    [{_, _, [{_, _, [_ | event_rows]}]}] =
      results_body
      |> Floki.find(".TableContents")

    event_rows
    |> EventSearchResults.from_cagematch_search_results()
    |> Enum.map(&Map.get(&1, :url))
  end

  @spec wwe_event_url_paths_list(year :: integer) :: [String.t()]
  def wwe_event_url_paths_list(year) do
    number_of_pages = number_of_results_pages(year)

    case number_of_pages do
      0 ->
        []

      _ ->
        1..number_of_pages
        |> Enum.reduce([], fn page_number, acc ->
          acc ++ wwe_event_url_paths_list(year, page_number)
        end)
    end
  end

  def wwe_upcoming_event_url_paths_list do
    results_body =
      get_page_html_body(
        "https://www.cagematch.net/?id=1&view=cards&name=&promotion=1&showtype=TV-Show%7CPay+Per+View"
      )

    [{_, _, [{_, _, [_ | event_rows]}]}] =
      results_body
      |> Floki.find(".TableContents")

    event_rows
    |> EventSearchResults.from_cagematch_upcoming_search_results()
    |> Enum.map(&Map.get(&1, :url))
  end

  @spec total_results(year :: integer) :: map
  defp total_results(year) do
    results_body = get_page_html_body(wwe_events_results_url(year, 1))

    results_info =
      results_body
      |> Floki.find(".TableHeaderOff")
      |> Floki.text()
      |> String.split()
      |> Enum.map(&Integer.parse(&1))
      |> Enum.filter(&is_tuple(&1))
      |> Enum.map(&elem(&1, 0))

    case results_info do
      [1, results_per_page, total_results] ->
        %{
          results_per_page: results_per_page,
          total_results: total_results
        }

      _ ->
        %{results_per_page: 1, total_results: 0}
    end
  end

  @spec number_of_results_pages(year :: integer) :: integer
  defp number_of_results_pages(year) do
    %{results_per_page: results_per_page, total_results: total_results} =
      total_results(year)

    total_results
    |> Kernel.-(1)
    |> div(results_per_page)
    |> Kernel.+(1)
  end

  @spec cp1252_to_utf8_converter(html :: String.t()) :: String.t()
  defp cp1252_to_utf8_converter(html) do
    Mbcs.decode!(html, :cp1252, return: :binary)
  end

  @spec wwe_events_results_url(year :: integer, page_number :: integer) ::
          String.t()
  def wwe_events_results_url(year, page_number) do
    results_number = (page_number - 1) * 100

    "https://www.cagematch.net/?id=1&view=search&sPromotion=1&sDateFromDay=01&sDateFromMonth=01&sDateFromYear=#{
      year
    }&sDateTillDay=31&sDateTillMonth=12&sDateTillYear=#{year}&sEventType=TV-Show%7CPay+Per+View&s=#{
      results_number
    }"
  end
end
