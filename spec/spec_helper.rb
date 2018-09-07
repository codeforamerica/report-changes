RSpec.configure do |config|
  unless ENV['CI']
    config.run_all_when_everything_filtered = true
    config.filter_run focus: true
  end
end
