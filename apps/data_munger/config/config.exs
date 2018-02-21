use Mix.Config

config :data_munger, ecto_repos: [DataMunger.Repo]

import_config "#{Mix.env}.exs"
