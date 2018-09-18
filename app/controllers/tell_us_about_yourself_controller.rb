class TellUsAboutYourselfController < FormsController
  def update_models
    @form.save
  end

  def assign_attributes_to_form
    super
    @form.change_report = current_change_report
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
end
