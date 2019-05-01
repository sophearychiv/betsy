class RemoveOrderId < ActiveRecord::Migration[5.2]
  def change
    remove_column :orderitems, :order_id
  end
end
