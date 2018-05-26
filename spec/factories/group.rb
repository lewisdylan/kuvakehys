FactoryBot.define do
  sequence :group_email do |n|
    "group-#{n}"
  end

  factory :group do
    name { SecureRandom.hex(5) }
    email { generate(:group_email) }
    recipient_country 'DE'
    photo_limit 25

    trait :with_recipients do
      transient do
        recipients_count 1
      end

      after(:create) do |group, evaluator|
        create_list(:recipient, evaluator.recipients_count, group: group)
      end
    end

    trait :with_photos do
      transient do
        photos_count 1
      end

      after(:create) do |group, evaluator|
        create_list(:photo, evaluator.photos_count, group: group)
      end
    end
  end
end
