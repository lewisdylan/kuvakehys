class CreateRecipientOrders < ActiveRecord::Migration
  def up
    create_table :recipient_orders do |t|
      t.integer :order_id
      t.integer :recipient_id
      t.integer :group_id
      t.string :print_order_id
      t.string :status

      t.timestamps null: false
    end
    Order.find_each do |order|
      order.group.recipients.each do |recipient|
        order.recipient_orders.create(print_order_id: order.print_order_id, status: order.status, recipient: recipient, group: order.group)
      end
    end
  end

  def down
    drop_table :recipient_orders
  end
end
