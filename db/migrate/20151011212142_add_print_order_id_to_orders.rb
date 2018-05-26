class AddPrintOrderIdToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :print_order_id, :string
  end
end
