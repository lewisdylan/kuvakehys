class Photo < ActiveRecord::Base

  belongs_to :group
  belongs_to :order
  belongs_to :user

  scope :open, -> { where('order_id IS NULL') }
  scope :ordered, -> { where('order_id IS NOT NULL') }
  scope :latest, -> { order('created_at DESC') }

  # we want to make sure photos are unique per group and order
  validates_uniqueness_of :picture_fingerprint, scope: [:group_id, :order_id], allow_blank: true
  before_save :analyze_picture

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
      sizing: 'Crop' # or 'ShrinkToFit' see http://www.pwinty.com/ApiDocs/Resizing
    }
  end

  def print_type
    if self.group && ['GB', 'US', 'BR', 'AU', 'CA', 'CL', 'MX'].include?(self.group.printing_country)
      '4x6'
    else
      (self.width.to_i > 600 && self.height.to_i > 900) ? '10x15_cm' : '9x13_cm'
    end
  end

  def has_bad_quality?
    self.width.to_i < 800 || self.height.to_i < 800
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
