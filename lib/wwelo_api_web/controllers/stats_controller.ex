defmodule WweloApiWeb.StatsController do
  use WweloApiWeb, :controller

  # import Ecto.Query
  # alias WweloApi.Repo
  # alias WweloApi.Stats.Wrestler

  action_fallback(WweloApiWeb.FallbackController)

  def index(conn, _params) do
    elos = [%{}]
    json(conn, elos)
  end

  def show(conn, %{"id" => id}) do
    elos = [%{id: id}]
    json(conn, elos)
  end
end
