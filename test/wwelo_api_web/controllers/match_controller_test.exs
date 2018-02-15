defmodule WweloApiWeb.MatchControllerTest do
  use WweloApiWeb.ConnCase

  alias WweloApi.Stats
  alias WweloApi.Stats.Match

  @create_attrs %{
    card_position: 42,
    event_id: 42,
    stipulation: "some stipulation"
  }
  @update_attrs %{
    card_position: 43,
    event_id: 43,
    stipulation: "some updated stipulation"
  }
  @invalid_attrs %{card_position: nil, event_id: nil, stipulation: nil}

  def fixture(:match) do
    {:ok, match} = Stats.create_match(@create_attrs)
    match
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all matches", %{conn: conn} do
      conn = get(conn, match_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create match" do
    test "renders match when data is valid", %{conn: conn} do
      conn = post(conn, match_path(conn, :create), match: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, match_path(conn, :show, id))

      assert json_response(conn, 200)["data"] == %{
               "id" => id,
               "card_position" => 42,
               "event_id" => 42,
               "stipulation" => "some stipulation"
             }
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, match_path(conn, :create), match: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update match" do
    setup [:create_match]

    test "renders match when data is valid", %{
      conn: conn,
      match: %Match{id: id} = match
    } do
      conn = put(conn, match_path(conn, :update, match), match: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, match_path(conn, :show, id))

      assert json_response(conn, 200)["data"] == %{
               "id" => id,
               "card_position" => 43,
               "event_id" => 43,
               "stipulation" => "some updated stipulation"
             }
    end

    test "renders errors when data is invalid", %{conn: conn, match: match} do
      conn = put(conn, match_path(conn, :update, match), match: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete match" do
    setup [:create_match]

    test "deletes chosen match", %{conn: conn, match: match} do
      conn = delete(conn, match_path(conn, :delete, match))
      assert response(conn, 204)

      assert_error_sent(404, fn ->
        get(conn, match_path(conn, :show, match))
      end)
    end
  end

  defp create_match(_) do
    match = fixture(:match)
    {:ok, match: match}
  end
end
