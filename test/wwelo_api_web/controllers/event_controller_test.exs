defmodule WweloApiWeb.EventControllerTest do
  use WweloApiWeb.ConnCase

  alias WweloApi.Stats
  alias WweloApi.Stats.Event

  @create_attrs %{arena: "some arena", brand: "some brand", date: ~D[2010-04-17], event_type: "some event_type", location: "some location", name: "some name", promotion: "some promotion"}
  @update_attrs %{arena: "some updated arena", brand: "some updated brand", date: ~D[2011-05-18], event_type: "some updated event_type", location: "some updated location", name: "some updated name", promotion: "some updated promotion"}
  @invalid_attrs %{arena: nil, brand: nil, date: nil, event_type: nil, location: nil, name: nil, promotion: nil}

  def fixture(:event) do
    {:ok, event} = Stats.create_event(@create_attrs)
    event
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all events", %{conn: conn} do
      conn = get conn, event_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create event" do
    test "renders event when data is valid", %{conn: conn} do
      conn = post conn, event_path(conn, :create), event: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, event_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "arena" => "some arena",
        "brand" => "some brand",
        "date" => ~D[2010-04-17],
        "event_type" => "some event_type",
        "location" => "some location",
        "name" => "some name",
        "promotion" => "some promotion"}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, event_path(conn, :create), event: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update event" do
    setup [:create_event]

    test "renders event when data is valid", %{conn: conn, event: %Event{id: id} = event} do
      conn = put conn, event_path(conn, :update, event), event: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, event_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "arena" => "some updated arena",
        "brand" => "some updated brand",
        "date" => ~D[2011-05-18],
        "event_type" => "some updated event_type",
        "location" => "some updated location",
        "name" => "some updated name",
        "promotion" => "some updated promotion"}
    end

    test "renders errors when data is invalid", %{conn: conn, event: event} do
      conn = put conn, event_path(conn, :update, event), event: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete event" do
    setup [:create_event]

    test "deletes chosen event", %{conn: conn, event: event} do
      conn = delete conn, event_path(conn, :delete, event)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, event_path(conn, :show, event)
      end
    end
  end

  defp create_event(_) do
    event = fixture(:event)
    {:ok, event: event}
  end
end
