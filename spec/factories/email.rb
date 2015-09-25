FactoryGirl.define do
  factory :email, class: OpenStruct do
    # Assumes Griddler.configure.to is :hash (default)
    to [{ raw: 'to_user@email.com', email: 'to_user@email.com', token: 'to_user', host: 'email.com' }]
    from 'user@email.com'
    subject 'email subject'
    body 'Hello!'
    attachments {[]}

    trait :with_attachment do
      attachments {[
        ActionDispatch::Http::UploadedFile.new({
          filename: 'image.jpg',
          type: 'image/jpeg',
          tempfile: File.new("#{File.expand_path File.dirname(__FILE__)}/../fixtures/image.jpg")
        })
      ]}
    end
  end
end
