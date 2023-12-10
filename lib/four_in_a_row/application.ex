defmodule FourInARow.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      FourInARowWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:four_in_a_row, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: FourInARow.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: FourInARow.Finch},
      # Start a worker by calling: FourInARow.Worker.start_link(arg)
      # {FourInARow.Worker, arg},
      # Start to serve requests, typically the last entry
      FourInARow.Presence,
      FourInARowWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: FourInARow.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    FourInARowWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
