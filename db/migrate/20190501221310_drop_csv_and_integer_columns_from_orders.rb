class DropCsvAndIntegerColumnsFromOrders < ActiveRecord::Migration[5.2]
  def change
    remove_column(:orders, :csv)
    remove_column(:orders, :integer)
  end
end
