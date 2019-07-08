defmodule PackagesBot.RubyGems do
  @behaviour PackagesBot.Adapter

  alias PackagesBot.RubyGems.Packages

  @impl true
  def bot_token do
    :packages_bot
    |> Application.fetch_env!(__MODULE__)
    |> Keyword.fetch!(:bot_token)
  end

  @impl true
  defdelegate search_package(pattern), to: Packages, as: :search
end
