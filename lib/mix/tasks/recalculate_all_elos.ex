defmodule Mix.Tasks.RecalculateAllElos do
  @moduledoc false
  use Mix.Task
  require Logger
  alias Wwelo.EloCalculator.EloCalculator
  alias Wwelo.EloCalculator.EloDeleter

  @shortdoc "Scrapes site and calculates elo from all matches"
  def run(_) do
    "Recalculating Elos" |> Logger.info()
    Mix.Task.run("app.start")
    {:ok, _started} = Application.ensure_all_started(:wwelo)
    EloDeleter.delete_all_elos()
    EloCalculator.calculate_elos()
  end
end
