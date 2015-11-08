FactoryGirl.define do
  sequence :group_email do |n|
    "group-#{n}"
  end

  factory :group do
    name { SecureRandom.hex(5) }
    email { generate(:group_email) }
    recipient_country 'DE'
    photo_limit 25
  end
end
