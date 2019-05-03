class OrdersController < ApplicationController
  before_action :require_login

  def index
    @orders = Order.all
  end

  def new
    @order = Order.new
  end

  def create
    @order = Order.new(order_params)
    if @order.save
      redirect_to confirmation_path
    else
      @order.errors.messages.each do |field, message|
        flash.now[field] = message
      end
      render :new, status: :bad_request
    end
  end

  def show
    @order = Order.find_by(id: params[:id])
    if @order.nil?
      flash[:error] = "Unknown order"
      redirect_to orders_path
    end
  end

  private

  def order_params
    return params.require(:order).permit(:address, :name, :status, :cc, :expiration_date, :email, :csv)
  end
end
