defmodule Wwelo.SiteScraper.Scraper do
  @moduledoc """
  Website information scraper module
  """

  alias Wwelo.SiteScraper.Events
  alias Wwelo.SiteScraper.Matches
  alias Wwelo.SiteScraper.Participants

  @doc """
  Saves event, match, participant, wrestler and alias information from all WWE tv shows and pay per views from the first WWE event to present day

  Returns a list (years) of lists (events) of lists (matches) of participants of matches

  ## Examples

    iex> Wwelo.SiteScraper.Scraper.scrape_site
    [[[1, 2], [3, 4, 5]], [[1, 3], [2, 4]]]

  """
  def scrape_site do
    # DateTime.utc_now().year
    years = 1963..1970

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

  # credo:disable-for-this-file
end
