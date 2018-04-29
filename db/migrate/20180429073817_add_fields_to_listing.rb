class AddFieldsToListing < ActiveRecord::Migration[5.1]
  def change
    add_column :listings, :is_shower, :boolean
    add_column :listings, :is_bicycle, :boolean
    add_column :listings, :is_wetsuit, :boolean
  end
end
