defmodule WweloApiWeb.MatchController do
  use WweloApiWeb, :controller

  alias WweloApi.Stats
  alias WweloApi.Stats.Match

  action_fallback(WweloApiWeb.FallbackController)

  def index(conn, _params) do
    matches = Stats.list_matches()
    render(conn, "index.json", matches: matches)
  end

  def create(conn, %{"match" => match_params}) do
    with {:ok, %Match{} = match} <- Stats.create_match(match_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", match_path(conn, :show, match))
      |> render("show.json", match: match)
    end
  end

  def show(conn, %{"id" => id}) do
    match = Stats.get_match!(id)
    render(conn, "show.json", match: match)
  end

  def update(conn, %{"id" => id, "match" => match_params}) do
    match = Stats.get_match!(id)

    with {:ok, %Match{} = match} <- Stats.update_match(match, match_params) do
      render(conn, "show.json", match: match)
    end
  end

  def delete(conn, %{"id" => id}) do
    match = Stats.get_match!(id)

    with {:ok, %Match{}} <- Stats.delete_match(match) do
      send_resp(conn, :no_content, "")
    end
  end
end
