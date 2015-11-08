FactoryGirl.define do
  factory :photo do
    sender_name "Maeve"
    sender_email "maeve@nairobi.com"
    picture { File.new("#{File.expand_path File.dirname(__FILE__)}/../fixtures/image.jpg") }
    message_id { SecureRandom.hex(5) }
    picture_fingerprint { SecureRandom.hex(5) }
  end
end

