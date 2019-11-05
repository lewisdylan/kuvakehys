class Membership < ActiveRecord::Base
  belongs_to :user
  belongs_to :collection
  belongs_to :invitation

  validates_presence_of :user_id, :collection_id
  validates_uniqueness_of :invitation_id, allow_blank: true
  validates_uniqueness_of :user_id, :scope => :collection_id
  before_save :insert_defaults

  def insert_defaults
    self.filter ||= {}
  end

  def as_json(args={})
    {
      collection_id: self.collection.identifier,
      collection: self.collection.as_json(ids_only: true),
      user_id: self.user.identifier,
      filter: self.filter,
      created_at: self.created_at
    }
  end
end
