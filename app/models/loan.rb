class Loan < ActiveRecord::Base
  has_many :payments

  def as_json(_opts = {})
    super.merge(outstanding_balance: outstanding_balance)
  end

  def outstanding_balance
    funded_amount - payments.sum(:amount)
  end
end
