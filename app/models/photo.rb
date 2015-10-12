class Photo < ActiveRecord::Base

  belongs_to :group
  belongs_to :order

  scope :open, -> { where('order_id IS NULL') }
  scope :ordered, -> { where('order_id IS NOT NULL') }

  after_create :create_order_if_full

  if Rails.env.production?
    has_attached_file :picture, styles: { small: '200', big: '600' },
      :path => ":class/:attachment/:id/:style/:hash.:extension",
      :hash_secret => ENV['PAPERCLIP_URL_SECRET']
  else
    has_attached_file :picture, styles: { small: '200', big: '600' }
  end

  validates_attachment :picture, presence: true,
      content_type: { content_type: "image/jpeg" }


  def to_order
    {
      type: self.print_type,
      url: self.picture.url,
      copies: 1,
      sizing: 'ShrinkToFit'
    }
  end

  def print_type
    '10x15_cm' # should be '9x13_cm' for smaller pictures
  end

  def create_order_if_full
    return if self.group.photos.open.count < self.group.photo_limit
    order = self.group.orders.create()
    self.group.photos.open.update_all(order_id: order.id)
    order.complete!
  end
end
