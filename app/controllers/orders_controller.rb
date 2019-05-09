class OrdersController < ApplicationController
  before_action :find_order, only: [:edit, :update, :show, :review, :confirmation, :destroy]

  def index
    @orders = Order.all
  end

  def update
    if @order.nil?
      redirect_to products_path
    else
      @order.update(status: Order::PENDING)
      is_successful = @order.update(order_params)
      if is_successful
        redirect_to review_order_path(@order.id)
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

  def review
  end

  def confirmation
    if @order.nil?
      redirect_to root_path
    else
      @order.update(status: Order::PAID)
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
      end
    end
  end

  def cancel
    @order = Order.find_by(id: params[:id])

    if @order.nil?
      flash[:status] = :error
      flash[:result_text] = "Order does not exist."
      redirect_to root_path
    else
      is_succesfull = @order.update(status: Order::CANCELLED)
      session[:order_id] = nil
      flash[:status] = :success
      flash[:result_text] = "Your order has been cancelled."

      redirect_to root_path
    end
  end

  private

  def find_order
    @order = Order.find_by(id: session[:order_id])
  end

  def order_params
    return params.require(:order).permit(:address, :name, :status, :cc, :expiration_date, :email, :csv)
  end
end
