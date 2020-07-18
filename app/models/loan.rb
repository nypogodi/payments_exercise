class Loan < ActiveRecord::Base
  has_many :payments

  def as_json(_opts = {})
    super(methods: :outstanding_balance)
  end

  def outstanding_balance
    funded_amount - payments.sum(:amount)
  end
end
