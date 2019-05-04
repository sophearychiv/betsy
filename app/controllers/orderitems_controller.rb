class OrderitemsController < ApplicationController
  def create
    @product = Product.find_by(id: params[:product_id])

    if @product
      # product_id, order_id, and quantity
      @orderitem = Orderitem.new(orderitems_params)
      @product.stock -= params[:quantity]

      if !@product.valid?
        flash[:error] = "An itsy problem occurred"
        @product.errors.messages.each do |field, messages|
          flash.now[field] = messages
        end
        redirect_to products_path(params[:product_id])
      end

      if !session[:order_id]
        order = Order.create
        session[:order_id] = order.id
      end

      @order_item.product_id = @product.id
      @order_item.order_id = session[:order_id]

      flash[:success] = "Succesfully added an itsy item to your cart"
      redirect_to orders_path
    else
      flash[:error] = "An itsy problem occurred: can't find product"
      redirect_to products_path
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def orderitem_params
    return params.require(:orderitem).permit(:quantity)
  end
end
