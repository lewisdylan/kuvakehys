FactoryBot.define do
  sequence :user_email do |n|
    "user-#{n}@tasveer.de"
  end
  factory :user do
    email { generate(:user_email) }
    group_id 1
    name 'Butare Rwanda'
  end

end
