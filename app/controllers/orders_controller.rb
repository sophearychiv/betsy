class OrdersController < ApplicationController
  before_action :find_order, only: [:edit, :update, :show, :confirmation]

  def index
    @orders = Order.all
  end

  # def new
  #   @order = Order.new

  # end

  def edit
  end

  def update
    @order.update(status: "pending")

    if @order.nil?
      redirect_to products_path
    else
      is_successful = @order.update(order_params)
      if is_successful
        redirect_to confirmation_path
      else
        @order.errors.messages.each do |field, message|
          flash.now[field] = message
        end

        render :edit, status: :bad_request
      end
    end
  end

  def create
    @order = Order.new(order_params)
    if @order.save
      redirect_to confirmation_path
    else
      @order.errors.messages.each do |field, message|
        flash.now[field] = message
      end
      render :edit, status: :bad_request
    end
  end

  def show
    if @order.nil?
      flash[:status] = :error
      flash[:result_text] = "Order not found!"
      redirect_to orders_path
    end
  end

  # def review
  #   @order = Order.find_by(id: session[:order_id])
  # end

  def confirmation
    if @order.nil?
      redirect_to root_path
    else
      @order.update(status: "paid")
      session[:order_id] = nil
      @temp_orderitems = []
      @order.orderitems.each do |item|
        hash = {
          orderitem_id: item.id,
          product_name: item.product.name,
          product_price: item.product.price,
          quantity: item.quantity,
          item_total: item.quantity * item.product.price,
        }

        @temp_orderitems << hash

        item.destroy
      end
    end
  end

  def destroy
    if @order.nil?
      flash[:status] = :error
      flash[:text_result] = "Order does not exist."
    else
      flash[:status] = :success
      flash[:text_result] = "Order has been canceled!"
      @order.destroy
    end

    redirect_to root_path
  end

  private

  def find_order
    @order = Order.find_by(id: session[:order_id])
  end

  def order_params
    return params.require(:order).permit(:address, :name, :status, :cc, :expiration_date, :email, :csv)
  end
end
