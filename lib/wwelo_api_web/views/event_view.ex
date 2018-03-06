defmodule WweloApiWeb.EventView do
  use WweloApiWeb, :view
  alias WweloApiWeb.EventView

  def render("index.json", %{events: events}) do
    %{data: render_many(events, EventView, "event.json")}
  end

  def render("show.json", %{event: event}) do
    %{data: render_one(event, EventView, "event.json")}
  end

  def render("event.json", %{event: event}) do
    %{
      id: event.id,
      name: event.name,
      promotion: event.promotion,
      date: event.date,
      event_type: event.event_type,
      location: event.location,
      arena: event.arena
    }
  end
end
