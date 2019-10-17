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
  alias Wwelo.StatsCache

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

  def handle_info({:ssl_closed, _msg}, state), do: {:noreply, state}

  defp schedule_work() do
    Process.send_after(self(), :work, 24 * 60 * 60 * 1000)
  end

  defp update_site do
    Logger.warn("Updating site")
    Scraper.scrape_site()
    Scraper.scrape_upcoming_events()
    EloCalculator.calculate_elos()
    Rosters.save_current_roster_to_database()
    TitleHolders.save_current_title_holders_to_database()
    # generate_sitemap()
    Logger.warn("Updating site complete")
    caches_cleared = Cachex.clear!(:wwelo_cache)
    Logger.warn(Integer.to_string(caches_cleared) <> " cleared from cache")
    StatsCache.cache_queries()
  end

  def generate_sitemap do
    "Running npm run generate-sitemap on ./assets" |> Logger.info()
    File.cd("assets")

    {generate_sitemap_errors, generate_sitemap_exit_code} =
      System.cmd("npm", ["run", "generate-sitemap"])

    File.cd("../")

    if generate_sitemap_exit_code == 0 do
      "No sitemap generation errors" |> Logger.warn()
      {:ok}
    else
      generate_sitemap_errors |> Logger.error()
      {:ok}
    end
  end
end
