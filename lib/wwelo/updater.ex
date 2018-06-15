defmodule Wwelo.Updater do
  @moduledoc """
    Updates the site daily
  """
  use GenServer
  alias Wwelo.EloCalculator.EloCalculator
  alias Wwelo.SiteScraper.Rosters
  alias Wwelo.SiteScraper.Scraper

  def start_link(state) do
    IO.puts("Updater initialised")
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
    Scraper.scrape_site()
    EloCalculator.calculate_elos()
    Rosters.save_current_roster_to_database()
  end

  defp schedule_work() do
    Process.send_after(self(), :work, 24 * 60 * 60 * 1000)
  end
end
