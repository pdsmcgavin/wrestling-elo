defmodule WweloApiWeb.AliasController do
  use WweloApiWeb, :controller

  alias WweloApi.Stats
  alias WweloApi.Stats.Alias

  action_fallback(WweloApiWeb.FallbackController)

  def index(conn, _params) do
    aliases = Stats.list_aliases()
    render(conn, "index.json", aliases: aliases)
  end

  def create(conn, %{"alias" => alias_params}) do
    with {:ok, %Alias{} = alias} <- Stats.create_alias(alias_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", alias_path(conn, :show, alias))
      |> render("show.json", alias: alias)
    end
  end

  def show(conn, %{"id" => id}) do
    alias = Stats.get_alias!(id)
    render(conn, "show.json", alias: alias)
  end

  def update(conn, %{"id" => id, "alias" => alias_params}) do
    alias = Stats.get_alias!(id)

    with {:ok, %Alias{} = alias} <- Stats.update_alias(alias, alias_params) do
      render(conn, "show.json", alias: alias)
    end
  end

  def delete(conn, %{"id" => id}) do
    alias = Stats.get_alias!(id)

    with {:ok, %Alias{}} <- Stats.delete_alias(alias) do
      send_resp(conn, :no_content, "")
    end
  end
end
