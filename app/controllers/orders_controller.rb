class OrdersController < ApplicationController
  before_action :find_order, only: [:edit, :update, :show, :confirmation, :destroy]

  def index
    @orders = Order.all
  end

  # def new
  #   @order = Order.new
  # end

  def edit
  end

  def update
    if @order.nil?
      redirect_to products_path
    else
      @order.update(status: "pending")
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

  def show
    if @order.nil?
      flash[:status] = :error
      flash[:result_text] = "Order not found!"
      redirect_to orders_path
    elsif @order.orderitems
      @order.orderitems.each do |item|
        orig_quantity = item.quantity
        new_quantity = item.adjust_quantity
        no_stock = true if new_quantity == 0
        if orig_quantity != new_quantity
          # had to write this in a weird way so that the test would pass
          if flash.now[:status] != :warning
            flash.now[:status] = :warning
            flash.now[:result_text] = "Some item quantities in your cart have changed due to availability: #{item.product.name}"
          else
            flash.now[:result_text] << ", #{item.product.name}"
          end
          item.destroy if no_stock
        end
      end
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
      flash[:result_text] = "Order does not exist."
    else
      @order.orderitems.each do |item|
        item.destroy
      end

      @order.destroy

      flash[:status] = :success
      flash[:result_text] = "Order has been canceled!"
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
