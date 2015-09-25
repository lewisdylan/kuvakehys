class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name
      t.string :email
      t.integer :photo_limit
      t.string :recipient_name
      t.string :recipient_street
      t.string :recipient_postal_code
      t.string :recipient_city

      t.timestamps null: false
    end
  end
end
