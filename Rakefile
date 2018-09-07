require_relative "config/application"

task :brakeman do
  sh "brakeman --no-pager"
end

task default: %w(bundler:audit brakeman spec)

Rails.application.load_tasks

task "db:schema:dump": "strong_migrations:alphabetize_columns"
