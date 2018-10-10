# Place idempotent, one off execution things here so they get auto-ran on deploy
namespace :one_offs do
  desc "runs all one_offs, remove things from here after they are deployed"
  task run_all: :environment do
    ChangeReport.where(change_type: nil).update_all(change_type: "job_termination")
  end
end
