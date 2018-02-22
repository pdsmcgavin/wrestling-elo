defmodule WweloApiWeb.ParticipantControllerTest do
  use WweloApiWeb.ConnCase

  alias WweloApi.Stats
  alias WweloApi.Stats.Participant

  @create_attrs %{
    elo_after: 42,
    match_id: 42,
    match_team: 42,
    outcome: "some outcome",
    alias_id: 42
  }
  @update_attrs %{
    elo_after: 43,
    match_id: 43,
    match_team: 43,
    outcome: "some updated outcome",
    alias_id: 43
  }
  @invalid_attrs %{
    elo_after: nil,
    match_id: nil,
    match_team: nil,
    outcome: nil,
    alias_id: nil
  }

  def fixture(:participant) do
    {:ok, participant} = Stats.create_participant(@create_attrs)
    participant
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all participants", %{conn: conn} do
      conn = get(conn, participant_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create participant" do
    test "renders participant when data is valid", %{conn: conn} do
      conn =
        post(conn, participant_path(conn, :create), participant: @create_attrs)

      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, participant_path(conn, :show, id))

      assert json_response(conn, 200)["data"] == %{
               "id" => id,
               "elo_after" => 42,
               "match_id" => 42,
               "match_team" => 42,
               "outcome" => "some outcome",
               "alias_id" => 42
             }
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn =
        post(conn, participant_path(conn, :create), participant: @invalid_attrs)

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update participant" do
    setup [:create_participant]

    test "renders participant when data is valid", %{
      conn: conn,
      participant: %Participant{id: id} = participant
    } do
      conn =
        put(
          conn,
          participant_path(conn, :update, participant),
          participant: @update_attrs
        )

      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, participant_path(conn, :show, id))

      assert json_response(conn, 200)["data"] == %{
               "id" => id,
               "elo_after" => 43,
               "match_id" => 43,
               "match_team" => 43,
               "outcome" => "some updated outcome",
               "alias_id" => 43
             }
    end

    test "renders errors when data is invalid", %{
      conn: conn,
      participant: participant
    } do
      conn =
        put(
          conn,
          participant_path(conn, :update, participant),
          participant: @invalid_attrs
        )

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete participant" do
    setup [:create_participant]

    test "deletes chosen participant", %{conn: conn, participant: participant} do
      conn = delete(conn, participant_path(conn, :delete, participant))
      assert response(conn, 204)

      assert_error_sent(404, fn ->
        get(conn, participant_path(conn, :show, participant))
      end)
    end
  end

  defp create_participant(_) do
    participant = fixture(:participant)
    {:ok, participant: participant}
  end
end
