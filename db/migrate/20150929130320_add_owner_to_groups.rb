class AddOwnerToGroups < ActiveRecord::Migration[5.0]
  def change
    add_column :groups, :owner_name, :string
    add_column :groups, :owner_email, :string
  end
end
