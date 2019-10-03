defmodule Mix.Tasks.PopulateDatabase do
  @moduledoc false
  use Mix.Task
  alias Wwelo.SiteScraper.Scraper
  alias Wwelo.EloCalculator.EloCalculator

  @shortdoc "Scrapes site and calculates elo from all matches"
  def run(_) do
    Mix.Task.run("app.start")
    {:ok, _started} = Application.ensure_all_started(:wwelo)

    Scraper.scrape_site()
    Scraper.scrape_upcoming_events()
    EloCalculator.calculate_elos()
  end
end
