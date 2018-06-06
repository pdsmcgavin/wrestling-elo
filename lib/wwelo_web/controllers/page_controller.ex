defmodule WweloWeb.PageController do
  use WweloWeb, :controller

  def index(conn, _params) do
    conn
    |> render("index.html")
  end
end
