class CreateRecipients < ActiveRecord::Migration
  def up
    create_table :recipients do |t|
      t.integer :group_id
      t.string :name
      t.string :address_1
      t.string :address_2
      t.string :postal_code
      t.string :city
      t.string :country

      t.timestamps null: false
    end

    Group.find_each do |group|
      group.recipients.create({
        name: group.recipient_name,
        address_1: group.recipient_address_1,
        address_2: group.recipient_address_2,
        postal_code: group.recipient_postal_code,
        city: group.recipient_city,
        country: group.recipient_country
      })
    end
  end

  def down
    drop_table :recipients
  end
end
