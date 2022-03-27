defmodule Teller.Sandbox.Application do
  @moduledoc false

  use Application

  alias Teller.SandboxWeb.Endpoint

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      Teller.SandboxWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Teller.Sandbox.PubSub},
      # Start the Endpoint (http/https)
      Endpoint
    ]

    opts = [strategy: :one_for_one, name: Teller.Sandbox.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    Endpoint.config_change(changed, removed)
    :ok
  end
end
