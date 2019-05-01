class RemoveProductidFromOrderitems < ActiveRecord::Migration[5.2]
  def change
    remove_column :orderitems, :product_id
  end
end
