class AddBankToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :bank_name, :string
    add_column :users, :account_type, :string
    add_column :users, :branch_code, :integer
    add_column :users, :account_number, :integer
    add_column :users, :account_name, :string
  end
end
