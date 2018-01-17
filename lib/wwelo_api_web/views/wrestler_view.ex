defmodule WweloApiWeb.WrestlerView do
  use WweloApiWeb, :view
  alias WweloApiWeb.WrestlerView

  def render("index.json", %{wrestlers: wrestlers}) do
    %{data: render_many(wrestlers, WrestlerView, "wrestler.json")}
  end

  def render("show.json", %{wrestler: wrestler}) do
    %{data: render_one(wrestler, WrestlerView, "wrestler.json")}
  end

  def render("wrestler.json", %{wrestler: wrestler}) do
    %{id: wrestler.id,
      name: wrestler.name,
      gender: wrestler.gender,
      height: wrestler.height,
      weight: wrestler.weight,
      career_start_date: wrestler.career_start_date,
      career_end_date: wrestler.career_end_date,
      wins: wrestler.wins,
      losses: wrestler.losses,
      draw: wrestler.draw,
      current_elo: wrestler.current_elo,
      maximum_elo: wrestler.maximum_elo,
      minimum_elo: wrestler.minimum_elo}
  end
end
