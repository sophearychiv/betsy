class ProductsController < ApplicationController
  before_action :find_product, only: [:show, :edit, :update, :status, :retire]
  before_action :find_merchant, only: [:new, :edit, :create]

  def index
    @products = Product.active_products
  end

  def show
    @orderitem = Orderitem.new
    @review = Review.new
    @reviews = @product.reviews
    if @product.active == false || @product.nil?
      flash[:status] = :warning
      flash[:result_text] = "#{@product.name} is not active."
      redirect_to dashboard_path
    end
  end

  # def by_cat
  #   id = params[:id]
  #   @category = Category.find_by(id: id)
  #   if @category
  #     @products_by_cat = Product.category_list(id)
  #   else
  #     render :notfound, status: :not_found
  #   end
  # end

  # def by_merch
  #   id = params[:id]
  #   @merchant = Merchant.find_by(id: id)
  #   if @merchant
  #     @products_by_merch = Product.merchant_list(id)
  #   else
  #     render :notfound, status: :not_found
  #   end
  # end

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
    # @categories = Category.all
    # if (session[:user_id] != params[:merchant_id].to_i) || (@product.merchant_id != session[:user_id])
    # render "layouts/notfound", status: :not_found
    if @product.nil?
      flash[:status] = :success
      flash[:result_text] = "Product not found."
      redirect_to dashboard_path
    end
  end

  def create
    if !session[:user_id].nil?
      params = product_params
      params[:merchant_id] = session[:user_id]
      params[:photo_url] = "http://placekitten.com/200/300" if params[:photo_url].empty?

      @product = Product.new(params)

      if @product.save
        flash[:status] = :success
        flash[:result_text] = "Successfully created #{@product.name}"
        redirect_to product_path(@product)
      else
        flash[:status] = :error
        flash[:result_text] = "Experiencing an issue with creating #{@product.id}."
        flash[:messages] = @product.errors.messages
        render :new
      end
    elsif session[:user_id].nil
      flash[:status] = :error
      flash[:result_text] = "Could not create #{@product}. Please sign in if you are authorized."
      redirect_to root_path
    end
  end

  def update
    @categories = Category.all
    if @product.update(product_params)
      merchant_id = session[:user_id]
      # @merchant_id = product_params[:merchant_id].to_i
      flash[:status] = :success
      flash[:result_text] = "Successfully updated #{@product.name}"
      redirect_to merchant_path(merchant_id)
    else
      flash[:status] = :failure
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
      # render :notfound, status: :not_found
    end
  end

  def product_params
    params.require(:product).permit(:name, :price, :description, :photo_url, :active, :merchant_id, :stock)
  end
end
