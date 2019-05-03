class ReviewsController < ApplicationController
  def new
    @review = Review.new
  end

  def create
    @product = Product.find_by(id: params[:product_id])
    @review = Review.new(review_params)

    if @product
      if @product.reviews << @review
        flash[:success] = "Thank you for your feedback"
        redirect_to product_path(params[:product_id])
      else
        flash[:error] = "An itsy problem occurred: Could not process feedback"
        @review.errors.messages.each do |field, messages|
          flash.now[field] = messages
        end
        render :new, status: :bad_request
      end
    else
      flash[:error] = "An itsy problem occurred: Product not found"
      redirect_to products_path
    end
  end

  def review_params
    return params.require(:review).permit(:rating, :body)
  end
end
