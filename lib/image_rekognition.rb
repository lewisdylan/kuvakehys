class ImageRekognition

  def self.bucket_name=(bucket_name)
    @@bucket_name = bucket_name
  end
  def self.bucket_name
    @@bucket_name
  end
  def self.client=(client)
    @@client = client
  end
  def self.client
    @@client
  end

  attr_accessor :key
  def initialize(key)
    self.key = key
  end

  def labels(options = {})
    @labels ||= self.class.client.detect_labels({
      image: {
        s3_object: { bucket: self.class.bucket_name, name: self.key }
      },
      max_labels: 5,
      min_confidence: 90
    }.merge(options))
  end

  def label_names(options={})
    self.labels(options).labels.map(&:name)
  end
end

