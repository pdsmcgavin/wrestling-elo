defmodule WweloApiWeb.MatchView do
  use WweloApiWeb, :view
  alias WweloApiWeb.MatchView

  def render("index.json", %{matches: matches}) do
    %{data: render_many(matches, MatchView, "match.json")}
  end

  def render("show.json", %{match: match}) do
    %{data: render_one(match, MatchView, "match.json")}
  end

  def render("match.json", %{match: match}) do
    %{id: match.id,
      event_id: match.event_id,
      stipulation: match.stipulation,
      card_position: match.card_position}
  end
end
