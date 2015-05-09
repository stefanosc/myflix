class Admin::PaymentsController < AdminsController
  def index
    @payments = Payment.all.includes(:user)
  end
end
