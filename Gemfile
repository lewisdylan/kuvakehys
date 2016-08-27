source 'https://rubygems.org'

gem 'rails', '5.0.0.1'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 3.0.2'
gem 'coffee-rails', '~> 4.2.1'
gem 'jquery-rails'

gem 'telegrammer'
gem 'griddler-mailgun'
gem 'pg'
gem 'lograge'
gem 'paperclip'
gem 'aws-sdk', '~> 1.6'
gem 'pwinty', git: 'https://github.com/bumi/pwinty.git'
gem 'country_select'
gem 'kaminari'
gem 'mad_id'

gem 'rollbar', '~> 2.12.0'
gem 'oj', '~> 2.17.3'

gem 'web-console', '~> 2.0', group: :development

group :test, :development do
  gem "rspec-rails"
  gem "factory_girl_rails"
  gem 'pry'
  gem 'pry-rails'
  gem 'dotenv-rails'
  gem 'spring'
  # gem 'therubyracer' - if you have problems withs node.js / asset compilation
  # gem 'sqlite3' - if you want to use sqlite3 for development
end
group :test do
  gem 'webmock'
end

group :production do
  gem 'rails_12factor'
  gem 'passenger', '>= 5.0.0'
end

