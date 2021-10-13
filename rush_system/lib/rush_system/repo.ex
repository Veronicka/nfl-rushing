defmodule RushSystem.Repo do
  use Ecto.Repo,
    otp_app: :rush_system,
    adapter: Ecto.Adapters.Postgres
end
