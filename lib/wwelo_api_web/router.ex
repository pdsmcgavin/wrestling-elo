defmodule WweloApiWeb.Router do
  use WweloApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", WweloApiWeb do
    pipe_through :api
  end
end
