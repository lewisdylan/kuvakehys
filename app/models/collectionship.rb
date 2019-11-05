class Collectionship < ActiveRecord::Base
  belongs_to :collection
  belongs_to :photo

  validates_uniqueness_of :photo_id, scope: :collection_id
end
