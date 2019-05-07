class ProductsController < ApplicationController
  before_action :find_product, only: [:show, :edit, :update, :status, :retire]
  before_action :find_merchant, only: [:new, :edit, :create]

  def index
    @products = Product.active_products
  end

  # def show
  #     @orderitem = Orderitem.new
  #     @review = Review.new
  #     @reviews = @product.reviews
  #   if @product.active == false || @product.nil?
  #     render :notfound, status: :not_found
  #   end
  # end

  # def by_merch
  #   id = params[:id]
  #   @merchant = Merchant.find_by(id:id)
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
       redirect_to products_path
    end
  end

  def new
  @product = Product.new
  end

  def edit

  end

  def create
    if !session[:user_id].nil?
      params = product_params
      params[:merchant_id] = session[:user_id]
      params[:photo_url] = "https://img.omdfarm.co.uk//images/1/5af9d353b2b83.jpg" if params[:photo_url].empty?

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
      @product.update(params)

      result = @product.save

      if result
        flash[:status] = :success
        flash[:result_text] = "Successfully updated product #{@product.name}"
        redirect_to product_path(@product.id)
      else
        flash[:status] = :failure
        flash[:result_text] = "Failed to update"
        flash[:messages] = @product.errors.messages
        render :edit, status: :bad_request
      end
    else
      redirect_back fallback_location: root_path, status: :bad_request
    end

private

  def find_product
  @product = Product.find_by(id: params[:id].to_i)

    if @product.nil?
      flash.now[:warning] = "Cannot find the product #{params[:id]}"
      render :notfound, status: :not_found
    end
  end

  def product_params
    params.require(:product).permit(:name, :price, :description, :photo_url, :active, :merchant_id, :stock)
  end
end
