class AddLicenseToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :license_image, :string
  end
end
