require 'rails_helper'

RSpec.describe LoansController, type: :controller do
  let(:payment) do
    Payment.create!(loan: loan, amount: payment_amount, payment_date: Date.today)
  end
  let(:payment_amount) { 0 }

  shared_examples_for 'has outstanding balance of' do |amt|
    it 'includes loan outstanding balance' do
      expect(JSON.parse(response.body)).to \
        include('outstanding_balance' => anything)
    end
  end

  describe '#index' do
    it 'responds with a 200' do
      get :index
      expect(response).to have_http_status(:ok)
    end
  end

  describe '#show' do
    let(:loan) { Loan.create!(funded_amount: 100.0) }

    it 'responds with a 200' do
      get :show, params: { id: loan.id }
      expect(response).to have_http_status(:ok)
    end

    context 'if the loan is not found' do
      it 'responds with a 404' do
        get :show, params: { id: 10000 }
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'loan with no payments' do
      before { get :show, params: { id: loan.id } }

      it_behaves_like 'has outstanding balance of', 100.0
    end

    context 'unpaid loan with payments' do
      let(:payment_amount) { 10 }

      before do
        [payment] * 2

        get :show, params: { id: loan.id }
      end

      it_behaves_like 'has outstanding balance of', 80.0
    end

    context 'loan is paid off' do
      let(:payment_amount) { 50 }

      before do
        [payment] * 2

        get :show, params: { id: loan.id }
      end

      it_behaves_like 'has outstanding balance of', 0.0
    end
  end
end
