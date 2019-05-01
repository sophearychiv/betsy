class CreateMerchants < ActiveRecord::Migration[5.2]
  def change
    create_table :merchants do |t|
      t.string :provider
      t.string :email
      t.string :username

      t.timestamps
    end
  end
end
