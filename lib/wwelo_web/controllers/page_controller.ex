defmodule WweloWeb.PageController do
  use WweloWeb, :controller

  alias Wwelo.Stats

  def index(conn, _params) do
    conn
    |> assign(:wrestler_info_list, Stats.list_wrestlers_elos(10))
    |> render("index.html")
  end
end
