defmodule Dg.Repo do
  use AshPostgres.Repo, otp_app: :dg

  def installed_extensions do
    ["uuid-ossp", "citext"]
  end
end
