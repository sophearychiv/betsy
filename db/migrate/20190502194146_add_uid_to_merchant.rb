class AddUidToMerchant < ActiveRecord::Migration[5.2]
  def change
    add_column :merchants, :uid, :string
  end
end
