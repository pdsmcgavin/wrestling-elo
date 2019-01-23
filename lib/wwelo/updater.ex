defmodule Wwelo.Updater do
  @moduledoc """
    Updates the site daily
  """
  use GenServer

  require Logger

  alias Wwelo.EloCalculator.EloCalculator
  alias Wwelo.SiteScraper.Rosters
  alias Wwelo.SiteScraper.Scraper
  alias Wwelo.SiteScraper.TitleHolders

  def start_link(state) do
    Logger.warn("Updater initialised")
    GenServer.start_link(__MODULE__, state)
  end

  def init(state) do
    update_site()
    schedule_work()
    {:ok, state}
  end

  def handle_info(:work, state) do
    update_site()
    schedule_work()
    {:noreply, state}
  end

  defp update_site do
    Logger.warn("Updating site")
    Scraper.scrape_site()
    EloCalculator.calculate_elos()
    Rosters.save_current_roster_to_database()
    TitleHolders.save_current_title_holders_to_database()
    Logger.warn("Updating site complete")
  end

  defp schedule_work() do
    Process.send_after(self(), :work, 24 * 60 * 60 * 1000)
  end
end
