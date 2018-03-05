defmodule WweloApiWeb.EloController do
  use WweloApiWeb, :controller

  alias WweloApi.Stats
  alias WweloApi.Stats.Elo

  action_fallback WweloApiWeb.FallbackController

  def index(conn, _params) do
    elos = Stats.list_elos()
    render(conn, "index.json", elos: elos)
  end

  def create(conn, %{"elo" => elo_params}) do
    with {:ok, %Elo{} = elo} <- Stats.create_elo(elo_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", elo_path(conn, :show, elo))
      |> render("show.json", elo: elo)
    end
  end

  def show(conn, %{"id" => id}) do
    elo = Stats.get_elo!(id)
    render(conn, "show.json", elo: elo)
  end

  def update(conn, %{"id" => id, "elo" => elo_params}) do
    elo = Stats.get_elo!(id)

    with {:ok, %Elo{} = elo} <- Stats.update_elo(elo, elo_params) do
      render(conn, "show.json", elo: elo)
    end
  end

  def delete(conn, %{"id" => id}) do
    elo = Stats.get_elo!(id)
    with {:ok, %Elo{}} <- Stats.delete_elo(elo) do
      send_resp(conn, :no_content, "")
    end
  end
end
