class LoansController < ActionController::API

  rescue_from ActiveRecord::RecordNotFound do |_|
    render json: 'not_found', status: :not_found
  end

  def index
    render json: Loan.all
  end

  def show
    render json: Loan.find(params[:id])
  end
end
