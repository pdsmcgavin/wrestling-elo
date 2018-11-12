defmodule Mix.Tasks.GetRosters do
  @moduledoc false
  use Mix.Task
  require Logger
  alias Wwelo.SiteScraper.Rosters

  @shortdoc "Scrapes site and gets the current rosters for all brands"
  def run(_) do
    "Getting rosters" |> Logger.info()
    Mix.Task.run("app.start")
    {:ok, _started} = Application.ensure_all_started(:wwelo)
    Rosters.save_current_roster_to_database()
  end
end
