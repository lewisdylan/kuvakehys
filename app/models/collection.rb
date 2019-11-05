class Collection < ActiveRecord::Base
  has_many :invitations, dependent: :destroy
  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships
  belongs_to :user

  has_many :collectionships, dependent: :destroy
  has_many :photos, through: :collectionships

  before_create :insert_defaults
  after_create :create_membership_for_user

  scope :latest, -> { order('created_at DESC') }
  # used to pass the filter of the creator to the membership
  attr_accessor :filter

  identify_with :cln

  def order!
    book = Kitely::Photobook.new(template: 'photobook_soft_14x14')
    book.front_cover = 'https://s3.amazonaws.com/sdk-static/TestImages/1.png'
    book.back_cover = 'https://s3.amazonaws.com/sdk-static/TestImages/1.png'
    self.photos.each do |photo|
      book.add_page(Rails.application.routes.url_helpers.rails_blob_url(photo.file, host: ENV['DEFAULT_HOST'], protocol: 'https'))
    end
    order = Kitely::Order.new(customer: self.user.to_kitely_customer)
    order.add(book)
    order.order!
  end

  def as_json(args={})
    super(args.merge(only: [:identifier, :name, :description, :photo_limit, :created_at])).tap do |h|
      h.merge!('photos_left' => self.photo_limit - self.photos.count)
      h.merge!({
        'photo_ids' => self.photos.pluck(:identifier),
        'user_ids' => self.users.pluck(:identifier)
      })
      unless args[:ids_only]
        h.merge!({
          'photos' => self.photos.map(&:as_json),
          'users' => self.users.map(&:as_json)
        })
      end
    end
  end

  def create_membership_for_user
    self.memberships.create(user: self.user, filter: self.filter)
  end

  def insert_defaults
    self.photo_limit = 36 # magic number
  end
end
