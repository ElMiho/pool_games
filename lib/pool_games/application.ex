defmodule PoolGames.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      #PoolGames.Repo, # Commented out as no (real) database is needed
      # Start the Telemetry supervisor
      PoolGamesWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: PoolGames.PubSub},
      # Start the Endpoint (http/https)
      PoolGamesWeb.Endpoint
      # Start a worker by calling: PoolGames.Worker.start_link(arg)
      # {PoolGames.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PoolGames.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    PoolGamesWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
