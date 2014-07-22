defmodule Repo do
  use Ecto.Repo, adapter: Ecto.Adapters.Postgres

  def conf, do: "not_important"
end
