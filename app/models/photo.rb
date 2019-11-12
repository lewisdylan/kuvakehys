class Photo < ActiveRecord::Base
  attr_accessor :add_to # used to associate collections by identifier

  belongs_to :user

  has_many :collectionships, dependent: :destroy
  has_many :collections, through: :collectionships

  scope :latest, -> { order('created_at DESC') }

  has_one_attached :file

  after_create :add_to_collections

  identify_with :pht

  Gutentag::ActiveRecord.call self

  # we want to make sure photos are unique per group and order
  # validates_uniqueness_of :picture_fingerprint, scope: [:collection_id], allow_blank: true

  def as_json(args={})
    h = super(args.merge({
      only: [:identifier, :caption, :picture_fingerprint, :picture_content_type],
      methods: [:tag_names, :width, :height]
    }))
    h.merge({
      file_url: Rails.application.routes.url_helpers.rails_blob_url(self.file, host: ENV['DEFAULT_HOST'], protocol: 'https'),
      # file_url: self.file.service_url,
      file_preview: (self.file.variant(resize: '1024x').processed.service_url rescue nil),
      user_id: self.user.identifier,
      collection_ids: self.collections.map(&:identifier)
    })
  end

  def add_to_collections
    self.collections << Array.wrap(self.add_to).map {|i| self.user.collections.find_by_mad_id(i) }.compact
  end

  def width
    self.file.metadata[:width]
  end

  def height
    self.file.metadata[:height]
  end

  def has_bad_quality?
    self.width.to_i < 800 || self.height.to_i < 800
  end

end
