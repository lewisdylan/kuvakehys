FactoryGirl.define do
  factory :group do
    name { SecureRandom.hex(5) }
  end
end
