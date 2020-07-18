class PaymentsController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound do |_|
    render json: 'not_found', status: :not_found
  end

  def index
    render json: loan.payments
  end

  def show
    render json: loan.payments.find(params[:id])
  end

  def create
    payment = create_payment

    if payment.errors.empty?
      render json: payment
    else
      render json: { errors: payment.errors.messages }, status: :unprocessable_entity
    end
  end

  private

  def create_payment
    loan = Loan.find(params[:loan_id])
    Payment.create(loan: loan, amount: params[:amount].to_d, payment_date: Date.parse(params[:payment_date]))
  end

  def loan
    @loan ||= Loan.find(params[:loan_id])
  end
end
