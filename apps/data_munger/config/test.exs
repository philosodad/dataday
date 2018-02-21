use Mix.Config

# Configure your database
config :data_munger, DataMunger.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "data_munger_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :data_munger, DataMunger.ImdbRepo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "data_imdb",
  hostname: "localhost",
  pool_size: 10
