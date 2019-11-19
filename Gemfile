source 'https://rubygems.org'

gem 'rails', '~>6.0.0'
gem 'uglifier'

gem "puma"
gem 'pg'
gem 'lograge'
gem 'mad_id'

gem 'oj'
gem 'gutentag'
gem "aws-sdk-s3", require: false
gem "aws-sdk-rekognition"
gem 'mini_magick'
gem 'pagy'
gem 'ougai'
gem 'kitely'


group :test, :development do
  gem 'awesome_print'
  gem 'listen'
  gem "rspec-rails"
  gem "factory_bot_rails"
  gem 'pry'
  gem 'pry-rails'
  gem 'dotenv-rails'
  gem 'spring'
  gem 'faker', '~> 2.7'
  # gem 'faker', :git => 'https://github.com/faker-ruby/faker.git', :branch => 'master'
  # gem 'therubyracer' - if you have problems withs node.js / asset compilation
  # gem 'sqlite3' - if you want to use sqlite3 for development
end
group :test do
  gem 'webmock'
end

group :production do
  gem 'rails_12factor'
end

