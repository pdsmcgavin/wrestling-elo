defmodule WweloApiWeb.AliasView do
  use WweloApiWeb, :view
  alias WweloApiWeb.AliasView

  def render("index.json", %{aliases: aliases}) do
    %{data: render_many(aliases, AliasView, "alias.json")}
  end

  def render("show.json", %{alias: alias}) do
    %{data: render_one(alias, AliasView, "alias.json")}
  end

  def render("alias.json", %{alias: alias}) do
    %{id: alias.id,
      name: alias.name,
      wrestler_id: alias.wrestler_id}
  end
end
