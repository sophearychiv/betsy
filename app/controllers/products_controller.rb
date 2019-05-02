class ProductsController < ApplicationController
  def retire
  @product.status = false
    if @product.save
       flash[:success] = "#{@product.name} has been retired."
       redirect_to products_path
    end
  end
end
