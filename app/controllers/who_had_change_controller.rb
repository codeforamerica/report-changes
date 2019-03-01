class WhoHadChangeController < FormsController
  before_action :clear_empty_members, :clear_empty_changes

  helper_method :who_had_change_collection

  def who_had_change_collection
    new_or_existing_submitter = [{ value: new_submitter_or_id, label: "Me" }]
    already_detailed_members = current_report.members.where(is_submitter: false).map do |member|
      { value: "existing_member_#{member.id}", label: member.full_name }
    end
    new_someone_else = [{ value: "new_someone_else", label: new_someone_else_label }]

    new_or_existing_submitter + already_detailed_members + new_someone_else
  end

  private

  def new_submitter_or_id
    if current_report.submitter.present?
      "existing_member_#{current_report.submitter.id}"
    else
      "new_submitter"
    end
  end

  def new_someone_else_label
    if current_report.members.where(is_submitter: false).empty?
      "Someone in my household"
    else
      "Someone else in my household"
    end
  end
end
