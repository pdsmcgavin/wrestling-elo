defmodule WweloApi.SiteScraper.Scraper do

    alias WweloApi.SiteScraper.SiteUrls

    def scrape_site() do
        years = 1963..2018

        years |> Enum.map(fn(x) -> SiteUrls.number_of_results_pages(%{year: x}) end)
    end
  
  end
  