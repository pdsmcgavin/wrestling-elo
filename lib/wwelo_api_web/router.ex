defmodule WweloApiWeb.Router do
  use WweloApiWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/api", WweloApiWeb do
    pipe_through(:api)
    resources("/aliases", AliasController, except: [:new, :edit])
    resources("/elos", EloController, except: [:new, :edit])
    resources("/events", EventController, except: [:new, :edit])
    resources("/matches", MatchController, except: [:new, :edit])
    resources("/participants", ParticipantController, except: [:new, :edit])
    resources("/wrestlers", WrestlerController, except: [:new, :edit])
  end
end
