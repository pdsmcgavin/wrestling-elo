defmodule Mix.Tasks.JsPreCommits do
  @moduledoc false
  use Mix.Task
  require Logger

  @shortdoc "Runs pre commit hooks for javascript files"
  def run(_) do
    IO.puts("Running eslint on ./assets")
    File.cd("assets")
    {linting_errors, linting_exit_code} = System.cmd("eslint", ["."])
    File.cd("../")

    if linting_exit_code == 0 do
      IO.puts("No linting errors")
      exit(:normal)
    end

    linting_errors |> Logger.info()
    exit({:shutdown, linting_exit_code})
  end
end
