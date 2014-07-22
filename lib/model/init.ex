defmodule Repo do
  use Ecto.Repo, adapter: Ecto.Adapters.Postgres, env: Mix.env

  def conf(_env), do: parse_url "not_important"
end
