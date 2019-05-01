class MakeProductTable < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.references :merchant, foreign_key: true
      t.string :name
      t.float :price
      t.string :description
      t.integer :stock
      t.string :photo_url
      t.boolean :active, default: true
      t.timestamps
    end
  end
end

