source 'https://rubygems.org'

gem 'rails', '4.2.4'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'jquery-rails'
gem 'jbuilder', '~> 2.0'

gem 'griddler-mailgun'
gem 'pg'
gem 'lograge'
gem "airbrake"
gem 'paperclip'
gem 'aws-sdk', '~> 1.6'
gem 'pwinty', git: 'https://github.com/bumi/pwinty.git'
gem 'country_select'
gem 'kaminari'
gem 'mad_id'

gem 'ongair', git: 'https://github.com/bumi/ongair.git'
gem 'telegrammer'
gem 'rollbar', '~> 2.4.0'
gem 'oj', '~> 2.12.14'

group :test, :development do
  gem "rspec-rails"
  gem "factory_girl_rails"
  gem 'pry'
  gem 'pry-rails'
  gem 'dotenv-rails'
  gem 'quiet_assets'
  gem 'spring'
  gem 'web-console', '~> 2.0'
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

gem 'sdoc', '~> 0.4.0', group: :doc
