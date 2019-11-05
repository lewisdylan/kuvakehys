if Rails.application.config.active_storage.service == :amazon && ENV['AWS_ACCESS_KEY_ID'].present?
  require Rails.root.join('lib/image_rekognition')
  require Rails.root.join('lib/tasveer_image_analyzer')
  aws_credentials = Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY'])
  ImageRekognition.client = Aws::Rekognition::Client.new(region: ENV['AWS_REGION'], credentials: aws_credentials)
  ImageRekognition.bucket_name = ENV['S3_BUCKET_NAME']

  # Use our image analyzer that uses the AWS image rekognition API
  #Rails.application.config.active_storage.analyzers.prepend TasveerImageAnalyzer
end
