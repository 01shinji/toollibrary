class AddAddressAndNicknameToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :address_zipcode, :string
    add_column :users, :address_prefecture_name, :string
    add_column :users, :address_city, :string
    add_column :users, :address_street, :string
    add_column :users, :address_building, :string
    add_column :users, :nickname, :string
  end
end
