defmodule WweloApi.SiteScraper.Utils.UrlHelper do
  def wwe_events_results_url(%{year: year, page_number: page_number}) do
    results_number = (page_number - 1) * 100

    "https://www.cagematch.net/?id=1&view=search&sPromotion=1&sDateFromDay=01&sDateFromMonth=01&sDateFromYear=#{
      year
    }&sDateTillDay=31&sDateTillMonth=12&sDateTillYear=#{year}&sEventType=TV-Show%7CPay+Per+View&s=#{
      results_number
    }"
  end

  def number_of_results(%{year: year}) do
    response =
      HTTPoison.get!(wwe_events_results_url(%{year: year, page_number: 1}))

    results_info =
      Floki.find(response.body, ".TableHeaderOff")
      |> Floki.text()
      |> String.split()
      |> Enum.map(&Integer.parse(&1))
      |> Enum.filter(&is_tuple(&1))
      |> Enum.map(&elem(&1, 0))

    case results_info do
      [1, results_per_page, number_of_results] ->
        %{
          results_per_page: results_per_page,
          number_of_results: number_of_results
        }

      _ ->
        %{results_per_page: 1, number_of_results: 0}
    end
  end

  def number_of_results_pages(%{year: year}) do
    %{results_per_page: results_per_page, number_of_results: number_of_results} =
      number_of_results(%{year: year})

    number_of_results
    |> Kernel.-(1)
    |> div(results_per_page)
    |> Kernel.+(1)
  end

  def wwe_event_url_paths_list(params = %{year: _, page_number: _}) do
    response = HTTPoison.get!(wwe_events_results_url(params))

    [{_, _, [{_, _, [_ | event_rows]}]}] =
      response.body |> Floki.find(".TableContents")

    event_rows
    |> Enum.map(fn event ->
      event
      |> PhStTransform.transform(%{Tuple => fn x -> Tuple.to_list(x) end})
      |> List.flatten()
      |> Enum.find(fn x -> String.starts_with?(x, "?id=1") end)
    end)
  end

  def wwe_event_url_paths_list(%{year: year}) do
    number_of_pages = number_of_results_pages(%{year: year})

    case number_of_pages do
      0 ->
        []

      _ ->
        1..number_of_pages
        |> Enum.reduce([], fn x, acc ->
          acc ++ wwe_event_url_paths_list(%{year: year, page_number: x})
        end)
    end
  end

  def cp1252_to_utf8_converter(html) do
    Mbcs.decode!(html, :cp1252, return: :binary)
  end
end