class CategoriesController < ApplicationController
  before_action :require_login, only: [:new, :create]

  def index
    @categories = Category.all
  end

  def show
    @category = Category.find_by(id: params[:id])

    if !@category
      flash[:status] = :warning
      flash[:result_text] = "A problem occurred: Media not found"
      redirect_to root_path
    end
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      flash[:status] = :success
      flash[:result_text] = "Successfully created #{@category.name} category"
      redirect_to merchant_path(session[:user_id])
    else
      flash[:status] = :warning
      flash[:result_text] = "An itsy problem occurred: Could not add category"
      @category.errors.messages.each do |field, messages|
        flash.now[field] = messages
      end
      render :new, status: :bad_request
    end
  end

  private

  def current_user
    @current_user ||= Merchant.find(session[:user_id]) if session[:user_id]
  end

  def require_login
    if current_user.nil?
      flash[:status] = :warning
      flash[:result_text] = "An itsy problem occurred: You must login to view this page"
      redirect_to root_path
    end
  end

  def category_params
    return params.require(:category).permit(:name)
  end
end
