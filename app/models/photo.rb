class Photo < ActiveRecord::Base

  belongs_to :group
  belongs_to :order

  scope :open, -> { where('order_id IS NULL') }
  scope :ordered, -> { where('order_id IS NOT NULL') }

  after_create :create_order_if_full
  after_create :notify_sender

  has_attached_file :picture, styles: { small: '200', big: '600' }
  validates_attachment :picture, presence: true,
      content_type: { content_type: "image/jpeg" }


  def create_order_if_full
    return if self.group.photos.open.count < self.group.photo_limit
    order = self.group.orders.create()
    self.group.photos.open.update_all(order_id: order.id)
    order.complete!
  end

  def notify_sender

  end
end
