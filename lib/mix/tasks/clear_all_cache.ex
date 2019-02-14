defmodule Mix.Tasks.ClearAllCache do
  @moduledoc false
  use Mix.Task
  require Logger

  @shortdoc "Clear all cached data"
  def run(_) do
    "Clearing all cache" |> Logger.info()
    Mix.Task.run("app.start")
    {:ok, _started} = Application.ensure_all_started(:wwelo)
    Cachex.clear(:wwelo_cache)
  end
end
