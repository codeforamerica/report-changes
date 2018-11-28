# Place idempotent, one off execution things here so they get auto-ran on deploy
namespace :one_offs do
  desc "runs all one_offs, remove things from here after they are deployed"
  task run_all: :environment do
    # Reassociate members and change reports
    ChangeReport.where(household_member_id: nil).each do |cr|
      member = HouseholdMember.find_by_change_report_id(cr.id)
      cr.update!(household_member_id: member.id) if member
    end

    # Reassociate change reports to navigators
    # Copy over has_letter from navigator to change report
    ChangeReport.where(navigator_id: nil).each do |cr|
      navigator = Navigator.find_by_change_report_id cr.id
      cr.update!(
        navigator_id: navigator.id,
        has_documents: navigator.has_documents
      ) if navigator
    end
  end
end
