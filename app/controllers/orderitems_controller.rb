class OrderitemsController < ApplicationController
  # def new
  #   @orderitem = Orderitem.new

  # end

  def create
    # raise
    @product = Product.find_by(id: params[:product_id])

    if @product
      # product_id, order_id, and quantity
      # @orderitem = Orderitem.new(orderitem_params)
      @orderitem = Orderitem.new(quantity: params[:quantity].to_i)
      @product.stock -= params[:quantity].to_i

      if !@product.valid?
        flash[:status] = :warning
        flash[:result_text] = "An itsy problem occurred"
        @product.errors.messages.each do |field, messages|
          flash.now[field] = messages
        end
        redirect_to product_path(params[:product_id])
        return
      end

      if !session[:order_id]
        @order = Order.create
        session[:order_id] = @order.id
      end
      @orderitem.product_id = @product.id
      @orderitem.order_id = session[:order_id]
      @orderitem.save
      flash[:status] = :success
      flash[:result_text] = "Succesfully added an itsy item to your cart"
      redirect_to orders_path
    else
      flash[:status] = :warning
      flash[:result_text] = "An itsy problem occurred: can't find product"
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

  # def orderitem_params
  #   return params.require(:orderitem).permit(:quantity)
  # end
end
