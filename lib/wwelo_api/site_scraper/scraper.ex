defmodule WweloApi.SiteScraper.Scraper do
  alias WweloApi.SiteScraper.Events
  alias WweloApi.SiteScraper.Matches

  def scrape_site() do
    years = 2018..2018

    years
    |> Enum.map(fn year ->
      event_match_list = Events.save_events_of_year(%{year: year})

      Enum.map(event_match_list, fn event ->
        match_result_list = Matches.save_matches_of_event(event)

        match_result_list
      end)
    end)
  end
end
