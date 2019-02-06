class WhoHadChangeForm < Form
  set_attributes_for :member, :new_or_existing_member

  validates_presence_of :new_or_existing_member

  def save
    member = if new_or_existing_member == "new_submitter"
               Member.create(is_submitter: true, report: report)

             elsif new_or_existing_member == "new_someone_else"
               Member.create(is_submitter: false, report: report)

             elsif new_or_existing_member&.include? "existing_member_"
               member_id = new_or_existing_member.split("existing_member_").last.to_i
               Member.find member_id

             else
               raise "Unknown member"
             end

    # Create the change using the type saved on the navigator
    change = Change.create(change_type: report.navigator.temp_change_type, member: member)
    ChangeNavigator.create(change: change)

    # Clear out temp_change_type
    report.navigator.update(temp_change_type: nil)

    # Save the member and change to the navigator for later reference
    report.navigator.update(current_member_id: member.id, current_change_id: change.id)
  end

  def self.existing_attributes(report)
    if report.current_member
      attributes = { new_or_existing_member: "existing_member_#{report.current_member.id}" }
      HashWithIndifferentAccess.new(attributes)
    else
      {}
    end
  end
end
