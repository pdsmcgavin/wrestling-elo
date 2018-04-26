defmodule Wwelo.SiteScraper.Scraper do
  alias Wwelo.SiteScraper.Events
  alias Wwelo.SiteScraper.Matches
  alias Wwelo.SiteScraper.Participants
  # credo:disable-for-this-file
  def scrape_site do
    years = 1963..DateTime.utc_now().year

    years
    |> Enum.map(fn year ->
      event_match_list = Events.save_events_of_year(%{year: year})

      Enum.map(event_match_list, fn event ->
        match_result_list = Matches.save_matches_of_event(event)

        Enum.map(match_result_list, fn match ->
          Participants.save_participants_of_match(match)
        end)
      end)
    end)
  end
end
