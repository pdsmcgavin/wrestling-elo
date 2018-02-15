defmodule WweloApiWeb.ParticipantController do
  use WweloApiWeb, :controller

  alias WweloApi.Stats
  alias WweloApi.Stats.Participant

  action_fallback(WweloApiWeb.FallbackController)

  def index(conn, _params) do
    participants = Stats.list_participants()
    render(conn, "index.json", participants: participants)
  end

  def create(conn, %{"participant" => participant_params}) do
    with {:ok, %Participant{} = participant} <-
           Stats.create_participant(participant_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", participant_path(conn, :show, participant))
      |> render("show.json", participant: participant)
    end
  end

  def show(conn, %{"id" => id}) do
    participant = Stats.get_participant!(id)
    render(conn, "show.json", participant: participant)
  end

  def update(conn, %{"id" => id, "participant" => participant_params}) do
    participant = Stats.get_participant!(id)

    with {:ok, %Participant{} = participant} <-
           Stats.update_participant(participant, participant_params) do
      render(conn, "show.json", participant: participant)
    end
  end

  def delete(conn, %{"id" => id}) do
    participant = Stats.get_participant!(id)

    with {:ok, %Participant{}} <- Stats.delete_participant(participant) do
      send_resp(conn, :no_content, "")
    end
  end
end
