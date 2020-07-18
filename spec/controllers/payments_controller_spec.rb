require 'rails_helper'

RSpec.describe PaymentsController, type: :controller do
  let(:loan) { Loan.create!(funded_amount: 100) }
  let(:payment) do
    Payment.create!(loan: loan, amount: payment_amount, payment_date: Date.today)
  end

  describe '#show' do
    let(:payment_amount) { 10 }

    it 'responds with a 200' do
      get :show, params: { loan_id: loan.id, id: payment.id }

      expect(response).to have_http_status(:ok)
      expect(response.body).to eq(payment.to_json)
    end
  end

  describe '#index' do
    let(:payment_amount) { 10 }
    let(:loan_with_payment) { payment && loan }

    it 'responds with a 200' do
      get :index, params: { loan_id: loan_with_payment.id }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).first.to_json).to eq(payment.to_json)
    end
  end

  describe '#create' do
    context 'payment amount is less than loan outstanding balance' do
      let(:amount) { 10 }

      before do
        post :create, params: { loan_id: loan.id, amount: amount, payment_date: Date.today }
      end

      it 'responds with a 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'creates a payment' do
        expect(Payment.count).to eq(1)
      end
    end

    context 'payment amount exceeds loan outstanding balance' do
      let(:amount) { 100.1 }

      before do
        post :create, params: { loan_id: loan.id, amount: amount, payment_date: Date.today }
      end

      it 'responds with an error' do
        expect(response).to have_http_status(:unprocessable_entity)

        expect(JSON.parse(response.body)['errors']).to \
          include(
            'outstanding_balance_exceeded' =>
            ["Payment amount of $100.1 exceeds loan outstanding balance of $100.0"]
          )
      end

      it 'does not create a payment' do
        expect(Payment.count).to eq(0)
      end
    end
  end
end
