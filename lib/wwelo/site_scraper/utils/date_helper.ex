defmodule Wwelo.SiteScraper.Utils.DateHelper do
  @moduledoc false

  @spec format_date(date :: String.t()) :: {:ok, Date.t()} | :error
  def format_date(date) do
    [day, month, year] =
      date
      |> String.split(".")
      |> case do
        [day, month, year] -> [day, month, year]
        [month, year] -> ["01", month, year]
        [year] -> ["01", "01", year]
      end
      |> Enum.map(fn time_length ->
        parsed_length = time_length |> Integer.parse()

        if parsed_length |> is_tuple() do
          parsed_length |> elem(0)
        else
          parsed_length
        end
      end)

    Date.new(year, month, day)
  end
end
