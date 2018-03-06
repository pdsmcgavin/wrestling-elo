defmodule WweloApiWeb.WrestlerControllerTest do
  use WweloApiWeb.ConnCase

  alias WweloApi.Stats
  alias WweloApi.Stats.Wrestler

  @create_attrs %{
    career_end_date: ~D[2010-04-17],
    career_start_date: ~D[2010-04-17],
    gender: "some gender",
    height: 42,
    name: "some name",
    weight: 42
  }
  @update_attrs %{
    career_end_date: ~D[2011-05-18],
    career_start_date: ~D[2011-05-18],
    gender: "some updated gender",
    height: 43,
    name: "some updated name",
    weight: 43
  }
  @invalid_attrs %{
    career_end_date: nil,
    career_start_date: nil,
    gender: nil,
    height: nil,
    name: nil,
    weight: nil
  }

  def fixture(:wrestler) do
    {:ok, wrestler} = Stats.create_wrestler(@create_attrs)
    wrestler
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all wrestlers", %{conn: conn} do
      conn = get(conn, wrestler_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create wrestler" do
    test "renders wrestler when data is valid", %{conn: conn} do
      conn = post(conn, wrestler_path(conn, :create), wrestler: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, wrestler_path(conn, :show, id))

      assert json_response(conn, 200)["data"] == %{
               "id" => id,
               "career_end_date" => "2010-04-17",
               "career_start_date" => "2010-04-17",
               "gender" => "some gender",
               "height" => 42,
               "name" => "some name",
               "weight" => 42
             }
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, wrestler_path(conn, :create), wrestler: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update wrestler" do
    setup [:create_wrestler]

    test "renders wrestler when data is valid", %{
      conn: conn,
      wrestler: %Wrestler{id: id} = wrestler
    } do
      conn =
        put(
          conn,
          wrestler_path(conn, :update, wrestler),
          wrestler: @update_attrs
        )

      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, wrestler_path(conn, :show, id))

      assert json_response(conn, 200)["data"] == %{
               "id" => id,
               "career_end_date" => "2011-05-18",
               "career_start_date" => "2011-05-18",
               "gender" => "some updated gender",
               "height" => 43,
               "name" => "some updated name",
               "weight" => 43
             }
    end

    test "renders errors when data is invalid", %{
      conn: conn,
      wrestler: wrestler
    } do
      conn =
        put(
          conn,
          wrestler_path(conn, :update, wrestler),
          wrestler: @invalid_attrs
        )

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete wrestler" do
    setup [:create_wrestler]

    test "deletes chosen wrestler", %{conn: conn, wrestler: wrestler} do
      conn = delete(conn, wrestler_path(conn, :delete, wrestler))
      assert response(conn, 204)

      assert_error_sent(404, fn ->
        get(conn, wrestler_path(conn, :show, wrestler))
      end)
    end
  end

  defp create_wrestler(_) do
    wrestler = fixture(:wrestler)
    {:ok, wrestler: wrestler}
  end
end
