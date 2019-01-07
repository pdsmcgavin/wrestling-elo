defmodule Mix.Tasks.GetTitleHolders do
  @moduledoc false
  use Mix.Task
  require Logger
  alias Wwelo.SiteScraper.TitleHolders

  @shortdoc "Scrapes site and gets the current title holders for all brands"
  def run(_) do
    "Getting title holders" |> Logger.info()
    Mix.Task.run("app.start")
    {:ok, _started} = Application.ensure_all_started(:wwelo)
    TitleHolders.save_current_title_holders_to_database()
  end
end
