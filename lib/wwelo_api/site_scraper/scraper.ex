defmodule WweloApi.SiteScraper.Scraper do
  alias WweloApi.SiteScraper.Events
  alias WweloApi.SiteScraper.Matches

  def scrape_site() do
    years = 2018..2018

    years
    |> Enum.each(fn year ->
      event_match_list = Events.save_events_of_year(%{year: year})

      Enum.each(event_match_list, fn event ->
        Matches.save_matches_of_event(event)
      end)
    end)
  end
end
