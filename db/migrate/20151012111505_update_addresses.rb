class UpdateAddresses < ActiveRecord::Migration
  def change
    add_column :groups, :recipient_address_2, :string
    rename_column :groups, :recipient_street, :recipient_address_1
    remove_column :groups, :address
  end
end
