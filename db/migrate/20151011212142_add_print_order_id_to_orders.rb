class AddPrintOrderIdToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :print_order_id, :string
  end
end
