class ProductsController < ApplicationController
  before_action :find_product, only: [:show, :edit, :update, :status, :retire]
  before_action :find_merchant, only: [:new, :edit, :create]
  before_action :require_login, only: [:new, :edit, :update, :create, :retire]

  def index
    @products = Product.active_products
  end

  def show
    if @product.nil?
      flash[:status] = :error
      flash[:result_text] = "Product does not exist."
      redirect_to dashboard_path
    elsif @product.active == false
      flash[:status] = :warning
      flash[:result_text] = "#{@product.name} is not active."
      redirect_to dashboard_path
    else
      @reviews = @product.reviews
    end
  end

  def retire
    @product.active = false
    if @product.save
      flash[:success] = "#{@product.name} has been retired."
      redirect_to dashboard_path
    end
  end

  def new
    @product = Product.new
  end

  def edit
    if @product.nil?
      flash[:status] = :success
      flash[:result_text] = "Product not found."
      redirect_to dashboard_path
    end
  end

  def create
    params = product_params
    params[:merchant_id] = session[:user_id]
    params[:photo_url] = "http://placekitten.com/200/300" if params[:photo_url].nil?

    @product = Product.new(params)

    if @product.save
      flash[:status] = :success
      flash[:result_text] = "Successfully created #{@product.name}"
      redirect_to product_path(@product)
    else
      flash[:status] = :error
      flash[:result_text] = "Experiencing an issue with creating the product."
      flash[:messages] = @product.errors.messages
      render :new, status: :bad_request
    end
  end

  def update
    if @product.update(product_params)
      merchant_id = session[:user_id]
      flash[:status] = :success
      flash[:result_text] = "Successfully updated #{@product.name}"
      redirect_to product_path(@product.id)
    else
      flash[:status] = :error
      flash[:result_text] = "Failed to update"
      flash[:messages] = @product.errors.messages
      render :edit, status: :bad_request
    end
  end

  private

  def find_product
    @product = Product.find_by(id: params[:id].to_i)

    if @product.nil?
      flash.now[:warning] = "Cannot find the product #{params[:id]}"
    end
  end

  def product_params
    params.require(:product).permit(:name, :price, :description, :photo_url, :active, :merchant_id, :stock, category_ids: [])
  end
end
