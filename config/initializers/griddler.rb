Griddler.configure do |config|
  config.processor_class = EmailPhotoProcessor
  config.email_service = :mailgun
end
