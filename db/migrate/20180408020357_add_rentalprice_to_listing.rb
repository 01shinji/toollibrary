class AddRentalpriceToListing < ActiveRecord::Migration[5.1]
  def change
    add_column :listings, :price_hour, :integer
    add_column :listings, :price_day, :integer
    add_column :listings, :price_month, :integer
  end
end
