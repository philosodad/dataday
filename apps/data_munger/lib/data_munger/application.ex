defmodule DataMunger.Application do
  @moduledoc """
  The DataMunger Application Service.

  The data_munger system business domain lives in this application.

  Exposes API to clients such as the `DataMungerWeb` application
  for use in channels, controllers, and elsewhere.
  """
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    Supervisor.start_link([
      supervisor(DataMunger.Repo, []),
      supervisor(DataMunger.ImdbRepo, []),
    ], strategy: :one_for_one, name: DataMunger.Supervisor)
  end
end
