class AddAttachmentLicenseToUsers < ActiveRecord::Migration[5.1]
  def self.up
    change_table :users do |t|
      t.attachment :license
    end
  end

  def self.down
    remove_attachment :users, :license
  end
end
