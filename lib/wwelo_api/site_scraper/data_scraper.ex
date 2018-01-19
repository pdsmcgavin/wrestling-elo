defmodule WweloApi.SiteScraper.DataScraper do

  def get_event_info(%{event_url_path: event_url_path}) do
    response = HTTPoison.get!("https://www.cagematch.net/"<>event_url_path)

    response.body
  end

end
