require 'rails_helper'

RSpec.describe Loan, type: :model do

  shared_examples_for 'has outstanding balance of' do |amt|
    it { expect(loan.outstanding_balance).to eq(amt) }
  end

  describe '#outstanding_balance' do
    let(:loan) { Loan.create!(funded_amount: 100.0) }

    context 'loan with no payments' do
      it_behaves_like 'has outstanding balance of', 100.0
    end

    context 'unpaid loan with payments' do
      before do
        (1..2).each{ |_| Payment.create!(loan: loan, amount: 10, payment_date: Date.today) }
      end

      it_behaves_like 'has outstanding balance of', 80.0
    end

    context 'loan is paid off' do
      before do
        (1..2).each{ |_| Payment.create!(loan: loan, amount: 50, payment_date: Date.today) }
      end

      it_behaves_like 'has outstanding balance of', 0.0
    end
  end
end
