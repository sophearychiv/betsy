class AddCsvColumnFromOrders < ActiveRecord::Migration[5.2]
  def change
    add_column(:orders, :csv, :integer)
  end
end
