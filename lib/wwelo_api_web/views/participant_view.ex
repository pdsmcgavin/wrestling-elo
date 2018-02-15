defmodule WweloApiWeb.ParticipantView do
  use WweloApiWeb, :view
  alias WweloApiWeb.ParticipantView

  def render("index.json", %{participants: participants}) do
    %{data: render_many(participants, ParticipantView, "participant.json")}
  end

  def render("show.json", %{participant: participant}) do
    %{data: render_one(participant, ParticipantView, "participant.json")}
  end

  def render("participant.json", %{participant: participant}) do
    %{
      id: participant.id,
      wrestler_id: participant.wrestler_id,
      match_id: participant.match_id,
      outcome: participant.outcome,
      elo_after: participant.elo_after,
      match_team: participant.match_team
    }
  end
end
