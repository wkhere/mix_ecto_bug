defmodule Subscribe do

  @spec days_from_payment(Payment.t) :: pos_integer
  def days_from_payment(p) do
    if p.currency == "PLN" do
          cond do
        p.amount >= 10 && p.amount < 27   -> 31
        p.amount >= 27 && p.amount < 54   -> 92
        p.amount >= 54 && p.amount < 108  -> 184
        p.amount >= 108                   -> 366
      end
    end
  end

  require Payment
  #def foo(%Payment{giver_address: addr}), do: :ok
end
