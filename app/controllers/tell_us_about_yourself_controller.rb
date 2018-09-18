class TellUsAboutYourselfController < FormsController
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
end
