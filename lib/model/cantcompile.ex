defmodule HereGoesWild do
  require Foo

  def f(%Foo{x: val}), do: val
end
