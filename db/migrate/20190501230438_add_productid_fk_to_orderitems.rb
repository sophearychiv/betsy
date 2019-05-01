class AddProductidFkToOrderitems < ActiveRecord::Migration[5.2]
  def change
    add_column :orderitems, :product, foreign_key: true
  end
end
