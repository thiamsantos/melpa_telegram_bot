use Mix.Config

fetch_env! = fn key ->
  case System.get_env(key) do
    nil -> raise ArgumentError, "Could not fetch environment #{key} because configuration #{key} was not set"
    value -> value
  end
end

config :packages_bot,
  ecto_repos: [PackagesBot.Repo]

config :packages_bot, PackagesBot.Repo, url: fetch_env!.("DATABASE_URL")

config :packages_bot, PackagesBot.Archive,
  renew_interval_in_seconds: "ARCHIVE_RENEW_INTERVAL_IN_SECONDS" |> fetch_env!.() |> String.to_integer()

config :packages_bot, PackagesBot.Melpa, bot_token: fetch_env!.("MELPA_BOT_TOKEN")
config :packages_bot, PackagesBot.Hexpm, bot_token: fetch_env!.("HEXPM_BOT_TOKEN")
config :packages_bot, PackagesBot.RubyGems, bot_token: fetch_env!.("RUBY_GEMS_BOT_TOKEN")

config :sentry, dsn: fetch_env!.("SENTRY_DSN")

config :packages_bot, PackagesBot.Endpoint,
  http: [port: String.to_integer(System.get_env("PORT") || "4000")],
  server: true
