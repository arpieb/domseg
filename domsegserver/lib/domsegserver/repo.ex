defmodule DOMSegServer.Repo do
  use Ecto.Repo,
    otp_app: :domsegserver,
    adapter: Ecto.Adapters.Postgres
end
