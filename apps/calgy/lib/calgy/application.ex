defmodule Calgy.Application do
  @moduledoc """
  The Calgy Application Service.

  The calgy system business domain lives in this application.

  Exposes API to clients such as the `CalgyWeb` application
  for use in channels, controllers, and elsewhere.
  """
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    Supervisor.start_link([
      supervisor(Calgy.Repo, []),
    ], strategy: :one_for_one, name: Calgy.Supervisor)
  end
end
