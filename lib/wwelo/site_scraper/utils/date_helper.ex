defmodule Wwelo.SiteScraper.Utils.DateHelper do
  @moduledoc false

  import Ecto.Query
  alias Wwelo.Repo
  alias Wwelo.Stats.Event

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

  def year_range do
    initial_year = 1963

    # credo:disable-for-lines:4
    last_event =
      from(e in Event, select: e.date, order_by: [desc: e.date])
      |> first
      |> Repo.one()

    years =
      case last_event do
        nil -> initial_year..DateTime.utc_now().year
        _ -> Map.get(Date.add(last_event, -30), :year)..DateTime.utc_now().year
      end

    years
  end
end
