defmodule WweloApi.SiteScraper.Scraper do
  alias WweloApi.SiteScraper.Events

  def scrape_site() do
    years = 1963..2018

    years |> Enum.each(fn year -> Events.save_events_of_year(%{year: year}) end)
  end
end
