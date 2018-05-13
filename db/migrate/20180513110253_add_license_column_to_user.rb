class AddLicenseColumnToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :license, :string
  end
end
