defmodule WweloApiWeb.WrestlerController do
  use WweloApiWeb, :controller

  alias WweloApi.Stats
  alias WweloApi.Stats.Wrestler

  action_fallback WweloApiWeb.FallbackController

  def index(conn, _params) do
    wrestlers = Stats.list_wrestlers()
    render(conn, "index.json", wrestlers: wrestlers)
  end

  def create(conn, %{"wrestler" => wrestler_params}) do
    with {:ok, %Wrestler{} = wrestler} <- Stats.create_wrestler(wrestler_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", wrestler_path(conn, :show, wrestler))
      |> render("show.json", wrestler: wrestler)
    end
  end

  def show(conn, %{"id" => id}) do
    wrestler = Stats.get_wrestler!(id)
    render(conn, "show.json", wrestler: wrestler)
  end

  def update(conn, %{"id" => id, "wrestler" => wrestler_params}) do
    wrestler = Stats.get_wrestler!(id)

    with {:ok, %Wrestler{} = wrestler} <- Stats.update_wrestler(wrestler, wrestler_params) do
      render(conn, "show.json", wrestler: wrestler)
    end
  end

  def delete(conn, %{"id" => id}) do
    wrestler = Stats.get_wrestler!(id)
    with {:ok, %Wrestler{}} <- Stats.delete_wrestler(wrestler) do
      send_resp(conn, :no_content, "")
    end
  end
end
