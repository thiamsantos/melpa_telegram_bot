use Mix.Config

__ENV__.file()
|> Path.dirname()
|> Path.join("./dotenv.exs")
|> Path.expand()
|> Code.eval_file()

config :packages_bot,
  ecto_repos: [PackagesBot.Repo],
  env: Mix.env()

config :packages_bot, PackagesBot.Repo, url: Dotenv.fetch_env!("DATABASE_URL")

config :packages_bot, PackagesBot.Melpa.Archive,
  renew_interval_in_seconds: Dotenv.fetch_integer_env!("ARCHIVE_RENEW_INTERVAL_IN_SECONDS")

config :packages_bot, PackagesBot.Melpa, bot_token: Dotenv.fetch_env!("MELPA_BOT_TOKEN")
config :packages_bot, PackagesBot.Hexpm, bot_token: Dotenv.fetch_env!("HEXPM_BOT_TOKEN")
config :packages_bot, PackagesBot.RubyGems, bot_token: Dotenv.fetch_env!("RUBY_GEMS_BOT_TOKEN")

config :packages_bot, PackagesBot.CurrentTime, adapter: PackagesBot.CurrentTime.SystemAdapter

import_config "#{Mix.env()}.exs"
