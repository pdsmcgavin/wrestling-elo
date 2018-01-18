defmodule WweloApi.SiteScraper.SiteUrls do

  def wwe_events_results_url(%{year: year, page_number: page_number}) do
    results_number = (page_number - 1)*100

    "https://www.cagematch.net/?id=1&view=search&sPromotion=1&sDateFromDay=01&sDateFromMonth=01&sDateFromYear=#{year}&sDateTillDay=31&sDateTillMonth=12&sDateTillYear=#{year}&sEventType=TV-Show%7CPay+Per+View&s=#{results_number}"
  end

  def wwe_event_urls_list(params = %{year: _, page_number: _}) do

    response = HTTPoison.get!(wwe_events_results_url(params))

     [_ | event_rows] = response.body
     |> Floki.find(".TableContents")
     |> Enum.at(0)
     |> elem(2)
     |> Enum.at(0)
     |> elem(2)

    event_rows
    |> Enum.map(fn(x) -> x
    |> elem(2)
    |> Enum.at(2)
    |> elem(2)
    |> Enum.at(2) end)

  end

end
