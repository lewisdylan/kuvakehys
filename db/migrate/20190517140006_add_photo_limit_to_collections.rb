class AddPhotoLimitToCollections < ActiveRecord::Migration[5.2]
  def change
    add_column :collections, :photo_limit, :integer
    Collection.find_each do |c|
      c.insert_defaults
      c.save
    end
  end
end
