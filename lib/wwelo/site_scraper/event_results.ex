defmodule Wwelo.SiteScraper.EventSearchResults do
  defstruct [:date, :name, :location, :url]
  @moduledoc false

  alias Wwelo.SiteScraper.Utils.DateHelper

  @type t() :: %__MODULE__{
          date: Date.t(),
          name: String.t(),
          location: String.t(),
          url: String.t()
        }

  @spec from_cagematch_search_results(html :: [{}]) :: [t()]
  def from_cagematch_search_results(html) do
    html
    |> Enum.map(fn {_, _,
                    [
                      _,
                      date_column,
                      name_column,
                      location_column,
                      _,
                      _,
                      _,
                      _
                    ]} ->
      {_, _, [date]} = date_column
      date = date |> DateHelper.format_date() |> elem(1)

      {_, [{_, url}], [name]} = name_column |> elem(2) |> Enum.at(-1)

      {_, _, [location]} = location_column

      %__MODULE__{date: date, name: name, location: location, url: url}
    end)
  end
end
