class AddFingerPrintToPhotos < ActiveRecord::Migration[5.0]
  def change
    add_column :photos, :picture_fingerprint, :string
  end
end
