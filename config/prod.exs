use Mix.Config

config :logger,
  level: :info,
  metadata: [:module],
  format: "$time $metadata[$level] $message\n"

config :timber,
  api_key: System.get_env("TIMBER_API_KEY"),
  source_id: System.get_env("TIMBER_SOURCE_ID")
