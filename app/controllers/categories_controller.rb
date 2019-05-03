class CategoriesController < ApplicationController
  def new
    @category = Category.new
  end

  def create
    if session[:user_id]
      @category = Category.new(category_params)
      if @category.save
        flash[:success] = "Successfully created #{@category.name} category"
        redirect_to merchant_path(session[:user_id])
      else
        flash[:error] = "An itsy problem occurred: Could not add category"
        @review.errors.messages.each do |field, messages|
          flash.now[field] = messages
        end
        render :create, status: :bad_request
      end
    else
      flash[:error] = "An itsy problem occurred: You must be logged in for that"
      redirect_to root_path
    end
  end

  def category_params
    return params.require(:category).permit(:name)
  end
end
