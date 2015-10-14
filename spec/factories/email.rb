FactoryGirl.define do
  factory :email, class: OpenStruct do
    # Assumes Griddler.configure.to is :hash (default)
    to [{ raw: 'to_user@email.com', email: 'to_user@email.com', token: 'to_user', host: 'email.com' }]
    from Hash[{ raw: 'from_user@email.com', name: 'from name', email: 'from_user@email.com', token: 'from_user', host: 'email.com' }]
    subject 'email subject'
    body 'Hello!'
    headers do {'Message-ID' => SecureRandom.hex(5) } end
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
