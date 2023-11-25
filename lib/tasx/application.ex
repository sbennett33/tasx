defmodule Tasx.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      TasxWeb.Telemetry,
      Tasx.Repo,
      {DNSCluster, query: Application.get_env(:tasx, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Tasx.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Tasx.Finch},
      # Start a worker by calling: Tasx.Worker.start_link(arg)
      # {Tasx.Worker, arg},
      # Start to serve requests, typically the last entry
      TasxWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Tasx.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TasxWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
