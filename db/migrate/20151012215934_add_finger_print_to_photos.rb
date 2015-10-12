class AddFingerPrintToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :picture_fingerprint, :string
  end
end
