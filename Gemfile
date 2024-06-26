source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.2"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.0.4"

# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 5.0"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
# gem "jbuilder"

# Use Redis adapter to run Action Cable in production
# gem "redis", "~> 4.0"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem "rack-cors"

# Added Gems
gem 'blueprinter'
gem 'composite_primary_keys', '=14.0.4'
gem 'devise', '~> 4.8.1'
gem 'devise_invitable', '~> 2.0.0'
gem 'devise-jwt', '~> 0.10.0'
gem 'jwt'
gem 'kaminari'
gem 'matrix'
gem 'openssl'
gem 'parallel'
gem 'prawn'
gem 'procore-sift'
gem 'pundit'
gem 'ransack'
gem 'redis'
gem 'redis-rails'
gem 'rqrcode'
gem 'rswag'
gem 'rswag-api'
gem 'rswag-ui'
gem 'rubyzip'
gem 'sidekiq'
gem 'sidekiq-batch'
gem 'sssecrets'
gem 'validates_timeliness', '~> 7.0.0.beta1'

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', platforms: %i[ mri mingw x64_mingw ]
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'json-schema'
  gem 'letter_opener_web', '~> 2.0.0'
  gem 'rspec-rails'
end

group :development do
  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
  gem 'annotate'
end

group :test do
  gem 'shoulda-matchers', '~> 5.0'
end
