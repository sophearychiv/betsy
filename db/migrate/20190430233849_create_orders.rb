class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.string :address
      t.string :name
      t.string :status
      t.integer :cc
      t.string :expiration_date
      t.string :date
      t.string :csv
      t.string :integer
      t.string :email

      t.timestamps
    end
  end
end
