# Place idempotent, one off execution things here so they get auto-ran on deploy
namespace :one_offs do
  desc "runs all one_offs, remove things from here after they are deployed"
  task run_all: :environment do
    # used to be report > changes
    # now is report > member > change
    Change.all.each do |change|
      # get the report_id from the old changes
      r_id = change.report_id
      # All old reports only have one member
      changes_member = Report.find(r_id).members.first
      # give changes a member
      change.update(member: changes_member)
    end

    # navigator.submitting_for moved to member.is_submitter
    Navigator.all.each do |navigator|
      # submitting_for is an enum, is_submitter is a boolean
      is_submitter = (navigator.submitting_for == "self")
      # update old members
      navigator.report.members.first.update(is_submitter: is_submitter)
    end

    # phone_number and case_number have moved from report to member
    Report.all.each do |report|
      report.members.first.update(
        phone_number: report.phone_number,
        case_number: report.case_number)
      end
    end
  end
end
