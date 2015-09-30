class AddAddressToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :address, :text
  end
end
