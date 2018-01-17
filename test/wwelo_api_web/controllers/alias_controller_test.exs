defmodule WweloApiWeb.AliasControllerTest do
  use WweloApiWeb.ConnCase

  alias WweloApi.Stats
  alias WweloApi.Stats.Alias

  @create_attrs %{name: "some name", wrestler_id: 42}
  @update_attrs %{name: "some updated name", wrestler_id: 43}
  @invalid_attrs %{name: nil, wrestler_id: nil}

  def fixture(:alias) do
    {:ok, alias} = Stats.create_alias(@create_attrs)
    alias
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all aliases", %{conn: conn} do
      conn = get conn, alias_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create alias" do
    test "renders alias when data is valid", %{conn: conn} do
      conn = post conn, alias_path(conn, :create), alias: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, alias_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "name" => "some name",
        "wrestler_id" => 42}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, alias_path(conn, :create), alias: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update alias" do
    setup [:create_alias]

    test "renders alias when data is valid", %{conn: conn, alias: %Alias{id: id} = alias} do
      conn = put conn, alias_path(conn, :update, alias), alias: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, alias_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "name" => "some updated name",
        "wrestler_id" => 43}
    end

    test "renders errors when data is invalid", %{conn: conn, alias: alias} do
      conn = put conn, alias_path(conn, :update, alias), alias: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete alias" do
    setup [:create_alias]

    test "deletes chosen alias", %{conn: conn, alias: alias} do
      conn = delete conn, alias_path(conn, :delete, alias)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, alias_path(conn, :show, alias)
      end
    end
  end

  defp create_alias(_) do
    alias = fixture(:alias)
    {:ok, alias: alias}
  end
end
