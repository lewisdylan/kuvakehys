class UpdateOrders < ActiveRecord::Migration[5.2]
  def change
    rename_column :orders, :group_id, :collection_id
    add_column :users, :address_line_1, :text
    add_column :users, :address_line_2, :text
    add_column :users, :city, :string
    add_column :users, :postcode, :string
    add_column :users, :country_code, :string
    add_column :users, :phone, :string
  end
end
