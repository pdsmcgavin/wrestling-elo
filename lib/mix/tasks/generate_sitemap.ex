defmodule Mix.Tasks.GenerateSitemap do
  @moduledoc false
  use Mix.Task
  require Logger

  @shortdoc "Runs sitemap generator"
  def run(_) do
    "Running npm run generate-sitemap on ./assets" |> Logger.info()
    File.cd("assets")

    {generate_sitemap_errors, generate_sitemap_exit_code} =
      System.cmd("npm", ["run", "generate-sitemap"])

    File.cd("../")

    if generate_sitemap_exit_code == 0 do
      "No sitemap generation errors" |> Logger.info()
      exit(:normal)
    end

    generate_sitemap_errors |> Logger.error()
    exit({:shutdown, generate_sitemap_exit_code})
  end
end
