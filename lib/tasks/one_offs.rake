# Place idempotent, one off execution things here so they get auto-ran on deploy
namespace :one_offs do
  desc "runs all one_offs, remove things from here after they are deployed"
  task run_all: :environment do
    ChangeReport.all.each do |change_report|
      if change_report.navigator.present?
        change_report.navigator.update!(
          is_self_employed: change_report.is_self_employed,
          submitting_for: change_report.submitting_for,
        )
      end

      unless change_report.metadata.present?
        change_report.create_metadata
      end
      change_report.metadata.update!(
        consent_to_sms: change_report.consent_to_sms,
        feedback_comments: change_report.feedback_comments,
        feedback_rating: change_report.feedback_rating,
      )
    end
  end
end
