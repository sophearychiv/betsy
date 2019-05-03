class OrdersController < ApplicationController
  def new
    @order = Order.new
  end

  def create
    @order = Order.new(order_params)
    if @order.save
      flash[:success] = "Your payment has been process! Thank you for your business!"
      redirect_to confirmation_path
    else
      @order.errors.messages.each do |field, message|
        flash.now[field] = message
      end
      render :new, status: :bad_request
    end
  end

  def show
  end

  private

  def order_params
    return params.require(:order).permit(:address, :name, :status, :cc, :expiration_date, :email, :csv)
  end
end
