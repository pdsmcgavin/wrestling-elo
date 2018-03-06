defmodule WweloApiWeb.EloControllerTest do
  use WweloApiWeb.ConnCase

  alias WweloApi.Stats
  alias WweloApi.Stats.Elo

  @create_attrs %{elo: 120.5, match_id: 42, wrestler_id: 42}
  @update_attrs %{elo: 456.7, match_id: 43, wrestler_id: 43}
  @invalid_attrs %{elo: nil, match_id: nil, wrestler_id: nil}

  def fixture(:elo) do
    {:ok, elo} = Stats.create_elo(@create_attrs)
    elo
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all elos", %{conn: conn} do
      conn = get(conn, elo_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create elo" do
    test "renders elo when data is valid", %{conn: conn} do
      conn = post(conn, elo_path(conn, :create), elo: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, elo_path(conn, :show, id))

      assert json_response(conn, 200)["data"] == %{
               "id" => id,
               "elo" => 120.5,
               "match_id" => 42,
               "wrestler_id" => 42
             }
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, elo_path(conn, :create), elo: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update elo" do
    setup [:create_elo]

    test "renders elo when data is valid", %{
      conn: conn,
      elo: %Elo{id: id} = elo
    } do
      conn = put(conn, elo_path(conn, :update, elo), elo: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, elo_path(conn, :show, id))

      assert json_response(conn, 200)["data"] == %{
               "id" => id,
               "elo" => 456.7,
               "match_id" => 43,
               "wrestler_id" => 43
             }
    end

    test "renders errors when data is invalid", %{conn: conn, elo: elo} do
      conn = put(conn, elo_path(conn, :update, elo), elo: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete elo" do
    setup [:create_elo]

    test "deletes chosen elo", %{conn: conn, elo: elo} do
      conn = delete(conn, elo_path(conn, :delete, elo))
      assert response(conn, 204)

      assert_error_sent(404, fn ->
        get(conn, elo_path(conn, :show, elo))
      end)
    end
  end

  defp create_elo(_) do
    elo = fixture(:elo)
    {:ok, elo: elo}
  end
end
