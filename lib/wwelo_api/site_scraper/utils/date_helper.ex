defmodule WweloApi.SiteScraper.Utils.DateHelper do
  def format_date(date) do
    [day, month, year] = String.split(date, ".")

    Ecto.Date.cast({year, month, day})
  end
end