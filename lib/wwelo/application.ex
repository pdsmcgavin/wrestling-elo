defmodule Wwelo.Application do
  @moduledoc false

  use Application
  alias WweloWeb.Endpoint

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    opts = [strategy: :one_for_one, name: Wwelo.Supervisor]

    :wwelo
    |> Application.get_env(:children)
    |> Supervisor.start_link(opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    Endpoint.config_change(changed, removed)
    :ok
  end
end
