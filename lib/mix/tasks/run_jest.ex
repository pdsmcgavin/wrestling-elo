defmodule Mix.Tasks.RunJest do
  @moduledoc false
  use Mix.Task
  require Logger

  @shortdoc "Runs front end tests"
  def run(_) do
    "Running tests on ./assets" |> Logger.info()
    File.cd("assets")
    {jest_errors, jest_exit_code} = System.cmd("npm", ["test"])
    File.cd("../")

    if jest_exit_code == 0 do
      "No jest errors" |> Logger.info()
      exit(:normal)
    end

    jest_errors |> Logger.error()
    exit({:shutdown, jest_exit_code})
  end
end
