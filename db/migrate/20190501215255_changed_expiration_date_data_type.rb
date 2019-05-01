class ChangedExpirationDateDataType < ActiveRecord::Migration[5.2]
  def change
    change_column(:orders, :expiration_date, "date USING CAST(expiration_date AS date)")
  end
end
