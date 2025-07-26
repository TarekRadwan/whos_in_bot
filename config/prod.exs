import Config

config :logger, level: :warn

config :whos_in_bot,
       WhosInBot.Repo,
       username: System.get_env("DB_USER", "postgres"),
       password: System.get_env("DB_PASSWORD", "postgres"),
       database: System.get_env("DB_NAME", "whos_in_bot"),
       hostname: System.get_env("DB_HOST", "localhost"),
       port: System.get_env("DB_PORT", "5432") |> String.to_integer(),
       ssl: System.get_env("DB_SSL", "false") |> String.to_atom()

config :whos_in_bot, WhosInBotWeb.Endpoint,
  http: [port: System.get_env("PORT", "5000") |> String.to_integer()],
  server: true

if File.exists?("prod.secret.exs") do
  import_config "prod.secret.exs"
end
