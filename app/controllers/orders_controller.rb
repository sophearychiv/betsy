class OrdersController < ApplicationController
  def index
    @orders = Order.all
  end

  # def new
  #   @order = Order.new

  # end

  def edit
    @order = Order.find_by(id: session[:order_id])
  end

  def update
    @order = Order.find_by(id: session[:order_id])
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
    end
  end

  def show
    @order = Order.find_by(id: session[:order_id])
    if @order.nil?
      flash[:error] = "Unknown order"
      redirect_to orders_path
    elsif @order.orderitems
      @order.orderitems.each do |item|
        orig_quantity = item.quantity
        new_quantity = item.adjust_quantity
        no_stock = true if new_quantity == 0
        if orig_quantity != new_quantity
          flash.now[:status] = :warning
          if !flash.now[:result_text]
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
    @order = Order.find_by(id: session[:order_id])
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
    @order = Order.find_by(id: session[:order_id])
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

  def order_params
    return params.require(:order).permit(:address, :name, :status, :cc, :expiration_date, :email, :csv)
  end
end
