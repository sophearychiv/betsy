class ProductsController < ApplicationController
before_action :find_product, only: [:show, :edit, :update, :retire]

  def index
    @products = Product.active_products
  end

  def show
    if @product.active == false || @product.nil?
      render :notfound, status: :not_found
    end
  end

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

  end

  def update

  end

private

  def find_product
  @product = Product.find_by(id: params[:id].to_i)

    if @product.nil?
      flash.now[:warning] = "Cannot find the product #{params[:id]}"
      render :notfound, status: :not_found
    end
  end
end
