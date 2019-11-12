FactoryBot.define do
  factory :photos do
    user { FactoryBot.create(:user) }
    identifier { Faker::Name.name }
    caption { Faker::String.random }
    width { Faker::Number.number(digits: 2) }
    height { Faker::Number.number(digits: 2) }
    file {Faker.file}
  end

end
