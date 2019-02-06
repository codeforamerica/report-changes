class WhoHadChangeController < FormsController
  helper_method :who_had_change_collection

  def who_had_change_collection
    new_or_existing_submitter = [{ value: new_submitter_or_id, label: "Me" }]
    new_someone_else = [{ value: "new_someone_else", label: "Someone in my household" }]

    already_detailed_members = current_report.members.where(is_submitter: false).map do |member|
      { value: "existing_member_#{member.id}", label: member.full_name }
    end
    new_or_existing_submitter + new_someone_else + already_detailed_members
  end

  private

  def new_submitter_or_id
    if current_report.submitter.present?
      "existing_member_#{current_report.submitter.id}"
    else
      "new_submitter"
    end
  end
end
