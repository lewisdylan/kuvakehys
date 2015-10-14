class Photo < ActiveRecord::Base

  belongs_to :group
  belongs_to :order
  belongs_to :user

  scope :open, -> { where('order_id IS NULL') }
  scope :ordered, -> { where('order_id IS NOT NULL') }

  validates_uniqueness_of :picture_fingerprint, scope: [:group_id, :message_id], allow_blank: true
  before_save :analyze_picture
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
    (self.width.to_i > 600 && self.height.to_i > 900) ? '10x15_cm' : '9x13_cm'
  end

  def create_order_if_full
    return if self.group.blank? || self.group.photos.open.count < self.group.photo_limit
    order = self.group.orders.create()
    self.group.photos.open.update_all(order_id: order.id)
  end

  def analyze_picture
    return if picture.blank?
    tempfile = picture.queued_for_write[:original]
    unless tempfile.nil?
      geometry = Paperclip::Geometry.from_file(tempfile)
      self.width = geometry.width.to_i
      self.height = geometry.height.to_i
    end
  end
end
