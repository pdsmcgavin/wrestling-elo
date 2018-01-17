defmodule WweloApi.SiteScraper.SiteUrls do

  def wwe_events__results_url(year, page_number) do
    results_number = (page_number - 1)*100

    "https://www.cagematch.net/?id=1&view=search&sPromotion=1&sDateFromDay=01&sDateFromMonth=01&sDateFromYear=#{year}&sDateTillDay=31&sDateTillMonth=12&sDateTillYear=#{year}&sEventType=TV-Show%7CPay+Per+View&s=#{results_number}"
  end

end
