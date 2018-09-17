class TellUsAboutYourselfController < FormsController
  def update_models
    change_report_data = params_for(:change_report)
    change_report_data[:phone_number] = change_report_data[:phone_number].delete("-")
    current_change_report.update!(change_report_data)
    member_data = params_for(:member)
    member_data.merge!(combined_birthday_fields(
                         day: member_data.delete(:birthday_day),
                         month: member_data.delete(:birthday_month),
                         year: member_data.delete(:birthday_year),
                       ))
    member_data[:ssn] = member_data[:ssn].delete("-")
    if current_change_report.member.present?
      current_change_report.member.update(member_data)
    else
      current_change_report.create_member(member_data)
    end
  end

  private

  def existing_attributes
    if current_change_report.member.present?
      attributes = current_change_report.attributes.merge(current_change_report.member.attributes)
      %i[year month day].each do |sym|
        attributes["birthday_#{sym}"] = current_change_report.member.birthday.try(sym)
      end
      attributes[:ssn] = current_change_report.member.ssn
      HashWithIndifferentAccess.new(attributes)
    else
      {}
    end
  end

  def combined_birthday_fields(day: nil, month: nil, year: nil)
    {
      birthday: DateTime.new(year.to_i, month.to_i, day.to_i),
    }
  end
end
