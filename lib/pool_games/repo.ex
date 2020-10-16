defmodule PoolGames.Repo do
  use Ecto.Repo,
    otp_app: :pool_games,
    adapter: Ecto.Adapters.Postgres
end
