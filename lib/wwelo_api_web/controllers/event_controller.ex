defmodule WweloApiWeb.EventController do
  use WweloApiWeb, :controller

  alias WweloApi.Stats
  alias WweloApi.Stats.Event

  action_fallback(WweloApiWeb.FallbackController)

  def index(conn, _params) do
    events = Stats.list_events()
    render(conn, "index.json", events: events)
  end

  def create(conn, %{"event" => event_params}) do
    with {:ok, %Event{} = event} <- Stats.create_event(event_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", event_path(conn, :show, event))
      |> render("show.json", event: event)
    end
  end

  def show(conn, %{"id" => id}) do
    event = Stats.get_event!(id)
    render(conn, "show.json", event: event)
  end

  def update(conn, %{"id" => id, "event" => event_params}) do
    event = Stats.get_event!(id)

    with {:ok, %Event{} = event} <- Stats.update_event(event, event_params) do
      render(conn, "show.json", event: event)
    end
  end

  def delete(conn, %{"id" => id}) do
    event = Stats.get_event!(id)

    with {:ok, %Event{}} <- Stats.delete_event(event) do
      send_resp(conn, :no_content, "")
    end
  end
end
