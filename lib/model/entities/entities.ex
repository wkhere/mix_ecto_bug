defmodule Foo do
  use Ecto.Model
  @type t :: %__MODULE__{}

  schema "foos" do
    field :x, :string
  end

  def func_using_other_mod(x) do
    OtherMod.f(x)
  end
end

defmodule Bar do
  use Ecto.Model

  schema "bars" do
    field :y, :string
  end
end
