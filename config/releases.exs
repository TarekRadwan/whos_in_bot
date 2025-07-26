import Config

config :logger, level: System.get_env("LOG_LEVEL", "info") |> String.to_atom()

config :whos_in_bot,
       WhosInBot.Repo,
       username: System.fetch_env!("DB_USER"),
       password: System.fetch_env!("DB_PASSWORD"),
       database: System.fetch_env!("DB_NAME"),
       hostname: System.fetch_env!("DB_HOST"),
       port: System.get_env("DB_PORT", "5432") |> String.to_integer(),
       ssl: System.get_env("DB_SSL", "false") |> String.to_atom(),
       pool_size: System.get_env("DB_POOL_SIZE", "10") |> String.to_integer()

config :nadia, token: System.fetch_env!("BOT_TOKEN")

# Set default port to 5000 if PORT env var is not set
config :whos_in_bot, port: System.get_env("PORT", "5000") |> String.to_integer()
