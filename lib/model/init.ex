defmodule Repo do
  use Ecto.Repo, adapter: Ecto.Adapters.Postgres, env: Mix.env

  def url(env) do
    u = System.get_env "DB_USER"
    p = System.get_env "DB_PASS"
    opts = if env == :test, do: "?size=1&max_overflow=0"
    "ecto://#{u}:#{p}@localhost/cday-#{env}#{opts}"
  end

  def conf(env), do: parse_url url(env)

  def log({:query, q}, f) do
    if Mix.env == :dev do
      {time, res} = :timer.tc(f)
      IO.puts "#{q} #{IO.ANSI.blue}[#{time} us]#{IO.ANSI.reset}"
      res
    else
      f.()
    end
  end
  def log(_, f), do: f.()
end
