defmodule WweloApi.SiteScraper.DataScraper do

  def get_event_info(%{event_url_path: event_url_path}) do
    response = HTTPoison.get!("https://www.cagematch.net/"<>event_url_path)

    response.body

    [{_, _, event_information}] = response.body |> Floki.find(".InformationBoxTable")
    # event_matches = response.body |> Floki.find(".Matches")

    event_information |> map_event_info
  end

  def map_event_info(event_info) do

    Enum.reduce(event_info, %{}, fn(x, acc) ->
      IO.inspect x
      case x do
        {_, _, [{_, _, ["Name of the event:"]}, {_, _, [event_name]}]} -> Map.put(acc, :name, event_name)
        {_, _, [{_, _, ["Promotion:"]}, {_, _, [{_, _, [promotion]}]}]} -> Map.put(acc, :promotion, promotion)
        {_, _, [{_, _, ["Type:"]}, {_, _, [event_type]}]} -> Map.put(acc, :event_type, event_type)
        {_, _, [{_, _, ["Location:"]}, {_, _, [location]}]} -> Map.put(acc, :location, location)
        {_, _, [{_, _, ["Arena:"]}, {_, _, [arena]}]} -> Map.put(acc, :arena, arena)
        {_, _, [{_, _, ["Date:"]}, {_, _, [date]}]} -> case format_date(date) do
                                                        {:ok, date} -> Map.put_new(acc, :date, date)
                                                        _ -> acc
                                                       end
        {_, _, [{_, _, ["Broadcast date:"]}, {_, _, [date]}]} -> case format_date(date) do
                                                                  {:ok, date} -> Map.put(acc, :date, date)
                                                                  _ -> acc
                                                                 end
        _ -> acc
      end
    end)

  end

  def format_date(date) do

    [day, month, year] = String.split(date, ".")

    Ecto.Date.cast({year, month, day})
  end

end
