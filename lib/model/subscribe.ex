defmodule Subscribe do
  # OFFENDING:
  require Payment

  # also OFFENDING:
  def foo(%Payment{giver_address: addr}), do: :ok
end
