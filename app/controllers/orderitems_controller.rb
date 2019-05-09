class OrderitemsController < ApplicationController
  def create
    # raise
    @product = Product.find_by(id: params[:product_id])

    if @product
      @orderitem = Orderitem.new(orderitem_params)
      # not actually changing stock, just using this as a device to generate errors
      @product.stock -= params[:orderitem][:quantity].to_i

      if !@product.valid?
        flash[:status] = :warning
        flash[:result_text] = "An itsy problem occurred: not enough available stock"
        redirect_to product_path(@product.id)
        return
      end

      if !session[:order_id]
        @order = Order.create
        session[:order_id] = @order.id
      end
      @orderitem.product_id = @product.id
      @orderitem.order_id = session[:order_id]
      is_successful = @orderitem.save

      if is_successful
        flash[:status] = :success
        flash[:result_text] = "Succesfully added an itsy item to your cart"
        redirect_to product_path(@product.id)
      else
        flash[:status] = :warning
        flash[:result_text] = "An itsy problem occurred: Could not add item to cart"
        @orderitem.errors.messages.each do |field, messages|
          flash.now[field] = messages
        end
        redirect_to product_path(@product.id)
      end
    else
      flash[:status] = :warning
      flash[:result_text] = "An itsy problem occurred: Can't find product"
      redirect_to products_path
    end
  end

  def update
    @orderitem = Orderitem.find_by(id: params[:id])
    if !@orderitem
      flash[:status] = :warning
      flash[:result_text] = "An itsy problem occurred: Could not find item"
      redirect_to root_path
    else
      @product = @orderitem.product
      # not actually changing stock, just using this as a device to generate errors
      @product.stock -= params[:quantity].to_i

      if !@product.valid?
        flash[:status] = :warning
        flash[:result_text] = "An itsy problem occurred: not enough available stock"
        redirect_to order_path(@orderitem.order.id)
        return
      end

      @orderitem.quantity = params[:quantity].to_i
      if @orderitem.save
        flash[:status] = :success
        flash[:result_text] = "Successfully updated item: #{@orderitem.product.name}"
        redirect_to order_path(@orderitem.order.id)
      else
        flash[:status] = :warning
        flash[:result_text] = "An itsy problem occurred: Could not update item"
        @orderitem.errors.messages.each do |field, messages|
          flash.now[field] = messages
        end
        redirect_to order_path(@orderitem.order.id)
      end
    end
  end

  def destroy
    orderitem = Orderitem.find_by(id: params[:id])
    if orderitem.nil?
      flash[:status] = :warning
      flash[:result_text] = "An itsy problem occurred: Could not find item"
      if !session[:order_id]
        redirect_to products_path
        return
      end
    else
      orderitem.destroy
      flash[:status] = :success
      flash[:result_text] = "Succesfully deleted item!"
    end
    redirect_to order_path(session[:order_id])
  end

  private

  def orderitem_params
    return params.require(:orderitem).permit(:quantity)
  end
end
