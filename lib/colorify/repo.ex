defmodule Colorify.Repo do
  use Ecto.Repo,
    otp_app: :colorify,
    adapter: Ecto.Adapters.Postgres
end
