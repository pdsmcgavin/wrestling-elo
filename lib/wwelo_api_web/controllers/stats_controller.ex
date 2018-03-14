defmodule WweloApiWeb.StatsController do
  use WweloApiWeb, :controller

  import Ecto.Query
  alias WweloApi.Repo
  alias WweloApi.Stats.Elo
  alias WweloApi.Stats.Event
  alias WweloApi.Stats.Match
  alias WweloApi.Stats.Wrestler

  action_fallback(WweloApiWeb.FallbackController)

  def index(conn, _params) do
    query =
      from(
        elos in Elo,
        join: m in Match,
        on: m.id == elos.match_id,
        join: e in Event,
        on: e.id == m.event_id,
        join: w in Wrestler,
        on: w.id == elos.wrestler_id
      )

    query =
      from(
        [elos, m, e, w] in query,
        select: %{name: w.name, date: e.date, elo: elos.elo},
        order_by: [
          asc: w.id,
          asc: e.date,
          asc: e.id,
          asc: m.card_position
        ]
      )

    elos =
      Repo.all(query)
      |> Enum.group_by(&Map.get(&1, :name), &Map.delete(&1, :name))

    json(conn, elos)
  end

  def show(conn, %{"id" => id}) do
    elos = [%{id: id}]
    json(conn, elos)
  end
end
