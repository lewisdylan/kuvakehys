class CreatePhotos < ActiveRecord::Migration[5.0]
  def change
    create_table :photos do |t|
      t.integer :group_id
      t.integer :order_id
      t.string :picture_file_name
      t.string :picture_content_type
      t.integer :picture_file_size
      t.integer :width
      t.integer :height
      t.string :sender_email
      t.string :sender_name
      t.text :message
      t.text :subject
      t.text :body
      t.string :message_id

      t.timestamps null: false
    end
  end
end
