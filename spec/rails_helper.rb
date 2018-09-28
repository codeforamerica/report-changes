# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= "test"
require File.expand_path("../config/environment", __dir__)
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?

require "spec_helper"
require "rspec/rails"
require "capybara/rails"
require "capybara/rspec"
require "selenium/webdriver"

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

Capybara.javascript_driver = :selenium_chrome_headless
Capybara.default_max_wait_time = 0.2

RSpec.configure do |config|
  config.use_transactional_fixtures = true
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.global_fixtures = :all
  config.example_status_persistence_file_path = "tmp/examples.txt"
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  config.include Warden::Test::Helpers, type: :feature
end
