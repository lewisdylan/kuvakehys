class AddInactivityReminderToUsers < ActiveRecord::Migration
  def change
    add_column :users, :last_inactivity_notifier_at, :datetime
    add_column :users, :inactivity_notifications_count, :integer, default: 0
    add_column :users, :last_import_at, :datetime
  end
end
