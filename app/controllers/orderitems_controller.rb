class OrderitemsController < ApplicationController
  def create
    @product = Product.find_by(id: params[:product_id])

    if @product
      @orderitem = Orderitem.new(quantity: params[:quantity].to_i)
      # needs to be updated when the product logic for in_stock? is updated
      # currently this isn't changing the stock count, which is good,
      # but is misleading as far as readability

      # talk to team, shouldn't be checking stock at this point in the process...
      # @product.stock -= params[:quantity].to_i

      # # makes sure the stock is available
      # if !@product.valid?
      #   flash[:status] = :warning
      #   flash[:result_text] = "An itsy problem occurred: not enough available stock"
      #   redirect_to product_path(@product.id)
      #   return
      # end

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
        flash[:result_text] = "An itsy problem occurred: could not add item to cart"
        @orderitem.errors.messages.each do |field, messages|
          flash.now[field] = messages
        end
        redirect_to products_path
      end
    else
      flash[:status] = :warning
      flash[:result_text] = "An itsy problem occurred: can't find product"
      redirect_to products_path
    end
  end

  def update
    @orderitem = Orderitem.find_by(id: params[:id])
    if !@orderitem
      flash[:status] = :warning
      flash[:result_text] = "An itsy problem occurred: Could not find item"
    else
      # talk to team... shouldn't be checking stock at this point in the proccess...
      # @product = @orderitem.product
      # # can be positive or negative depending on orderitem quantity change being made
      # @product.stock += quantity_difference

      # if !@product.valid?
      #   flash[:status] = :warning
      #   flash[:result_text] = "An itsy problem occurred: not enough available stock"
      #   redirect_to order_path(session[:order_id])
      #   return
      # end

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
    else
      orderitem.destroy
      flash[:status] = :success
      flash[:result_text] = "Succesfully deleted item!"
      redirect_to order_path(session[:order_id])
    end
  end

  private

  def orderitem_params
    return params.require(:orderitem).permit(:quantity)
  end
end
