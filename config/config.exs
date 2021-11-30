import Config

config :tictactoe, Tictactoe.Repo,
       database: "tictactoe_dev",
       username: "postgres",
       password: "postgres",
       hostname: "localhost"

config :tictactoe, ecto_repos: [Tictactoe.Repo]

import_config "#{config_env()}.exs"
