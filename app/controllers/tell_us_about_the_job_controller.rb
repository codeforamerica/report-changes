class TellUsAboutTheJobController < FormsController
  private

  def existing_attributes
    attributes = current_change_report.attributes
    %i[year month day].each do |sym|
      attributes["last_day_#{sym}"] = current_change_report.last_day.try(sym)
      attributes["last_paycheck_#{sym}"] = current_change_report.last_paycheck.try(sym)
    end
    HashWithIndifferentAccess.new(attributes)
  end
end
