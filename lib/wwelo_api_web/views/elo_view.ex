defmodule WweloApiWeb.EloView do
  use WweloApiWeb, :view
  alias WweloApiWeb.EloView

  def render("index.json", %{elos: elos}) do
    %{data: render_many(elos, EloView, "elo.json")}
  end

  def render("show.json", %{elo: elo}) do
    %{data: render_one(elo, EloView, "elo.json")}
  end

  def render("elo.json", %{elo: elo}) do
    %{
      id: elo.id,
      wrestler_id: elo.wrestler_id,
      match_id: elo.match_id,
      elo: elo.elo
    }
  end
end
