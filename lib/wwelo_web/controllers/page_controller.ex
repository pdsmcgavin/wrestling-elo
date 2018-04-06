defmodule WweloWeb.PageController do
  use WweloWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
