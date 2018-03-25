class CreateListings < ActiveRecord::Migration[5.1]
  def change
    create_table :listings do |t|
      t.string :listing_title
      t.string :listing_type
      t.string :category1
      t.string :category2
      t.integer :price
      t.string :price_per
      t.text :description
      t.string :location
      t.boolean :active
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
