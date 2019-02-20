defmodule Wwelo.SiteScraper.Utils.EventInfoConverterHelper do
  @moduledoc false

  alias Wwelo.SiteScraper.Utils.DateHelper

  @spec convert_event_info(event_info :: {}, acc :: map) :: map
  def convert_event_info(
        {_, _, [{_, _, ["Name of the event:"]}, {_, _, [event_name]}]},
        acc
      ) do
    Map.put(acc, :name, event_name)
  end

  def convert_event_info(
        {_, _, [{_, _, ["Promotion:"]}, {_, _, [{_, _, [promotion]}]}]},
        acc
      ) do
    Map.put(acc, :promotion, promotion)
  end

  def convert_event_info(
        {_, _, [{_, _, ["Type:"]}, {_, _, [{_, _, [event_type]}]}]},
        acc
      ) do
    case event_type do
      "TV-Show" -> Map.put(acc, :event_type, :tv_show)
      "Pay Per View" -> Map.put(acc, :event_type, :ppv)
      _ -> acc
    end
  end

  def convert_event_info(
        {_, _, [{_, _, ["Location:"]}, {_, _, [{_, _, [location]}]}]},
        acc
      ) do
    Map.put(acc, :location, location)
  end

  def convert_event_info(
        {_, _, [{_, _, ["Arena:"]}, {_, _, [{_, _, [arena]}]}]},
        acc
      ) do
    Map.put(acc, :arena, arena)
  end

  def convert_event_info(
        {_, _, [{_, _, ["Date:"]}, {_, _, [{_, _, [date]}]}]},
        acc
      ) do
    case DateHelper.format_date(date) do
      {:ok, date} -> Map.put_new(acc, :date, date)
      _ -> acc
    end
  end

  def convert_event_info(
        {_, _, [{_, _, ["Broadcast date:"]}, {_, _, [date]}]},
        acc
      ) do
    case DateHelper.format_date(date) do
      {:ok, date} -> Map.put(acc, :date, date)
      _ -> acc
    end
  end

  def convert_event_info(_, acc) do
    acc
  end
end
