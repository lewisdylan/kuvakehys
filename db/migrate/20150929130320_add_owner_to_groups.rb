class AddOwnerToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :owner_name, :string
    add_column :groups, :owner_email, :string
  end
end
