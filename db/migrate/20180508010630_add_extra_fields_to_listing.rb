class AddExtraFieldsToListing < ActiveRecord::Migration[5.1]
  def change
    add_column :listings, :purchase_price, :integer
    add_column :listings, :purchase_time, :string
  end
end
