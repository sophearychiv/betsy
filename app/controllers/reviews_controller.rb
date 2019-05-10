class ReviewsController < ApplicationController
  def new
    @review = Review.new
  end

  def create
    @product = Product.find_by(id: params[:product_id])
    @review = Review.new(review_params)

    if @product
      if @product.merchant_id == session[:user_id]
        flash[:status] = :error
        flash[:result_text] = "An itsy problem occurred: You can't rate your own products"
        redirect_to dashboard_path(session[:user_id])
        return
      end

      if @product.reviews << @review
        flash[:status] = :success
        flash[:result_text] = "Thank you for your feedback"
        redirect_to product_path(params[:product_id])
      else
        flash[:status] = :error
        flash[:result_text] = "An itsy problem occurred: Could not process feedback"
        @review.errors.messages.each do |field, messages|
          flash.now[field] = messages
        end
        render :new, status: :bad_request
      end
    else
      flash[:status] = :error
      flash[:result_text] = "An itsy problem occurred: Product not found"
      redirect_to products_path
    end
  end

  def review_params
    return params.require(:review).permit(:rating, :body)
  end
end
