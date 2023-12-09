defmodule Dg.Repo do
  use Ecto.Repo,
    otp_app: :dg,
    adapter: Ecto.Adapters.Postgres
end
