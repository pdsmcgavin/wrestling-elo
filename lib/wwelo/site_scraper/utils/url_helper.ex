defmodule Wwelo.SiteScraper.Utils.UrlHelper do
  @moduledoc false
  import Ecto.Query
  alias Wwelo.Repo
  alias Wwelo.SiteScraper.Utils.DateHelper
  alias Wwelo.Stats.Event

  def get_page_html_body(%{url: url}) do
    response = HTTPoison.get!(url)

    response.body |> cp1252_to_utf8_converter
  end

  def wwe_event_url_paths_list(%{year: _, page_number: _} = params) do
    results_body =
      get_page_html_body(%{
        url: wwe_events_results_url(params)
      })

    [{_, _, [{_, _, [_ | event_rows]}]}] =
      results_body |> Floki.find(".TableContents")

    event_rows
    |> unsaved_event_urls
  end

  def wwe_event_url_paths_list(%{year: year}) do
    number_of_pages = number_of_results_pages(%{year: year})

    case number_of_pages do
      0 ->
        []

      _ ->
        1..number_of_pages
        |> Enum.reduce([], fn page_number, acc ->
          acc ++
            wwe_event_url_paths_list(%{year: year, page_number: page_number})
        end)
    end
  end

  defp unsaved_event_urls(event_rows) do
    Enum.reduce(event_rows, [], fn {_, _,
                                    [
                                      _,
                                      date_column,
                                      name_column,
                                      location_column,
                                      _,
                                      _,
                                      _,
                                      _
                                    ]},
                                   acc ->
      {_, _, [date]} = date_column
      date = date |> DateHelper.format_date() |> elem(1)

      {_, [{_, url}], [name]} = name_column |> elem(2) |> Enum.at(-1)

      {_, _, [location]} = location_column

      event_query =
        from(
          e in Event,
          where: e.name == ^name and e.date == ^date and e.location == ^location,
          select: e
        )

      event_result = Repo.one(event_query)

      if event_result |> is_nil() do
        acc ++ [url]
      else
        acc
      end
    end)
  end

  defp total_results(%{year: year}) do
    results_body =
      get_page_html_body(%{
        url: wwe_events_results_url(%{year: year, page_number: 1})
      })

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

  defp number_of_results_pages(%{year: year}) do
    %{results_per_page: results_per_page, total_results: total_results} =
      total_results(%{year: year})

    total_results
    |> Kernel.-(1)
    |> div(results_per_page)
    |> Kernel.+(1)
  end

  defp cp1252_to_utf8_converter(html) do
    Mbcs.decode!(html, :cp1252, return: :binary)
  end

  defp wwe_events_results_url(%{year: year, page_number: page_number}) do
    results_number = (page_number - 1) * 100

    "https://www.cagematch.net/?id=1&view=search&sPromotion=1&sDateFromDay=01&sDateFromMonth=01&sDateFromYear=#{
      year
    }&sDateTillDay=31&sDateTillMonth=12&sDateTillYear=#{year}&sEventType=TV-Show%7CPay+Per+View&s=#{
      results_number
    }"
  end
end
