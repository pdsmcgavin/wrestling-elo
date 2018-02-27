defmodule WweloApi.SiteScraper.Wrestlers do
  import Ecto.Query

  alias WweloApi.Repo
  alias WweloApi.Stats
  alias WweloApi.Stats.Wrestler
  alias WweloApi.SiteScraper.Utils.UrlHelper

  def get_wrestler_info(%{wrestler_url_path: wrestler_url_path}) do
    wrestler_url = "https://www.cagematch.net/" <> wrestler_url_path

    wrestler_info =
      UrlHelper.get_page_html_body(%{url: wrestler_url})
      |> Floki.find(".InformationBoxRow")

    wrestler_info
  end

  def save_wrestler_to_database(wrestler_info) do
    wrestler_query =
      from(
        w in Wrestler,
        where: w.name == ^wrestler_info.name,
        select: w
      )

    wrestler_result = Repo.one(wrestler_query)

    case wrestler_result do
      nil -> Stats.create_wrestler(wrestler_info) |> elem(1)
      _ -> wrestler_result
    end
  end
end
