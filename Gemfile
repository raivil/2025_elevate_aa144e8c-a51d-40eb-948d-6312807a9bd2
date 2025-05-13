source "https://rubygems.org"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 8.0.2"
# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"
# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"
# Build JSON APIs with ease [https://github.com/rails/jbuilder]
# gem "jbuilder"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Use the database-backed adapters for Rails.cache, Active Job, and Action Cable
gem "solid_cache"
gem "solid_queue"
gem "solid_cable"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Deploy this application anywhere as a Docker container [https://kamal-deploy.org]
gem "kamal", require: false

# Add HTTP asset caching/compression and X-Sendfile acceleration to Puma [https://github.com/basecamp/thruster/]
gem "thruster", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin Ajax possible
# gem "rack-cors"

gem 'devise'
gem 'devise-jwt'
gem 'rack-cors'
gem 'active_model_serializers'
gem "anyway_config", "~> 2.6.4"
gem "auto_strip_attributes", "~> 2.6.0"
gem "database_validations", "~> 1.1.1"
gem "faraday", "~> 2.12.0"
gem "strong_migrations", "~> 2.0.0"
gem 'pluck_in_batches'

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"

  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem "brakeman", require: false
  gem "factory_bot_rails", "~> 6.4.3"
  gem "faker", "~> 3.4.2"
  gem "rspec_junit_formatter", "~> 0.6.0"
  gem "rspec-rails", "~> 7.0.1"
  # Omakase Ruby styling [https://github.com/rails/rubocop-rails-omakase/]
  gem "rubocop-rails-omakase", require: false
  gem "shoulda-matchers", "~> 6.4.0"
  gem "vcr", "~> 6.3.1"
  gem "webmock" # , "~> 3.19.1"
end

group :development do
  gem "rubocop", "~> 1.75.5"
  gem "rubocop-factory_bot", "~> 2.26.1", require: false
  gem "rubocop-performance", "~> 1.22.1"
  gem "rubocop-rails", "~> 2.26.2"
  gem "rubocop-rspec", "~> 3.1.0"
end

group :test do
  gem "fuubar", "~> 2.5.1"
  gem "simplecov", "~> 0.22.0", require: false
  gem "simplecov_json_formatter", "~> 0.1", require: false
end
