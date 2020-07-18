class Payment < ActiveRecord::Base
  belongs_to :loan

  validate :outstanding_loan_balance_not_exceded?, on: :create

  def outstanding_loan_balance_not_exceded?
    if amount > loan.outstanding_balance
      errors.add(
        :outstanding_balance_exceeded,
        "Payment amount of $#{amount} exceeds loan outstanding balance of $#{loan.outstanding_balance}"
      )
      end
  end
end
