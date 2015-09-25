class Photo < ActiveRecord::Base

  belongs_to :group
  belongs_to :order

  has_attached_file :picture, styles: { small: '300', big: '600' }
  validates_attachment :picture, presence: true,
      content_type: { content_type: "image/jpeg" }

end
