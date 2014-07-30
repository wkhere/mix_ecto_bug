defmodule User do
  use Ecto.Model
  @type t :: %__MODULE__{}

  schema "users" do
    has_many :subscriptions, Subscription
    field :name,  :string
    field :email, :string
  end

  @spec valid_subscription(t, Util.fuzzy_date) :: Subscription.t
  def valid_subscription(self, for_day) do
    for_day = Util.to_date for_day
    subs = Repo.all(from s in Subscription, where: s.user_id == ^self.id and
      s.started_on_day <= ^for_day and ^for_day <= s.expire_on_day)
    # sanity:
    if Enum.count(subs) > 1, do: raise "Too many subscriptions: #{inspect subs}"
    List.first subs
  end
end

defmodule Subscription do
  use Ecto.Model
  @type t :: %__MODULE__{}

  schema "subscriptions" do
    belongs_to :user, User
    has_many   :payment_matches, PayMatch
    field :started_on_day, :date
    field :expire_on_day,  :date
    field :is_gift,        :boolean
    field :created_at,     :datetime # todo: how to use server-side now() ?
  end
end

defmodule Payment do
  use Ecto.Model
  @type t :: %__MODULE__{}

  schema "payments" do
    has_many   :sub_matches, PayMatch
    # todo: somehow remember paid_by - if sub.receiver(s) is/are different
    #   than payer
    field :exec_date,      :date
    field :order_date,     :date
    field :amount,         :float
    field :currency,       :string
    field :ending_balance, :float
    field :giver_account,  :string
    field :giver_address,  :string
  end

  @spec subscriptions(t) :: [Subscription.t]
  def subscriptions(self) do
    Repo.all(from pm in PayMatch, where: pm.payment_id == ^self.id,
      join: s in pm.subscription, select: s)
  end
end

defmodule PayMatch do
  use Ecto.Model
  @type t :: %__MODULE__{}

  schema "payment_match", primary_key: false do
    belongs_to :subscription, Subscription
    belongs_to :payment,      Payment
    field :match_type,        :string
    field :new_subscription,  :boolean
    field :needs_email,       :boolean
    field :for_day,           :date
    field :created_at,        :datetime
    field :updated_at,        :datetime
  end
end
