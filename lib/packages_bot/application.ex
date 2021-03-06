defmodule PackagesBot.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = children(env())

    {:ok, _} = Logger.add_backend(Sentry.LoggerBackend)

    opts = [strategy: :one_for_one, name: PackagesBot.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp children(:test) do
    [
      PackagesBotWeb.Endpoint
    ]
  end

  defp children(_) do
    [
      {Task.Supervisor, name: PackagesBot.MessageSupervisor},
      PackagesBot.Melpa.Archive,
      {PackagesBot.Poller, adapter: PackagesBot.Melpa},
      {PackagesBot.Poller, adapter: PackagesBot.Hexpm},
      {PackagesBot.Poller, adapter: PackagesBot.RubyGems},
      PackagesBotWeb.Endpoint
    ]
  end

  defp env do
    Application.fetch_env!(:packages_bot, :env)
  end
end
