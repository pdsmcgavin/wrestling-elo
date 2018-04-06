defmodule Wwelo.SiteScraper.Utils.DateHelper do
  def format_date(date) do
    [day, month, year] =
      case String.split(date, ".") do
        [day, month, year] -> [day, month, year]
        [month, year] -> [01, month, year]
        [year] -> [01, 01, year]
      end

    Ecto.Date.cast({year, month, day})
  end
end
