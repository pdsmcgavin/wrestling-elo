defmodule Mix.Tasks.RunEslint do
  @moduledoc false
  use Mix.Task
  require Logger

  @shortdoc "Runs eslint"
  def run(_) do
    "Running eslint on ./assets" |> Logger.info()
    File.cd("assets")
    {linting_errors, linting_exit_code} = System.cmd("eslint", ["."])
    File.cd("../")

    if linting_exit_code == 0 do
      "No eslint errors" |> Logger.info()
      exit(:normal)
    end

    linting_errors |> Logger.error()
    exit({:shutdown, linting_exit_code})
  end
end
