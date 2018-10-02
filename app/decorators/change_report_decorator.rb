class ChangeReportDecorator < SimpleDelegator
  def formatted_company_phone_number
    if company_phone_number
      "(#{company_phone_number[0..2]}) #{company_phone_number[3..5]}-#{company_phone_number[6..9]}"
    end
  end

  def formatted_ssn
    "#{member.ssn[0..2]}-#{member.ssn[3..4]}-#{member.ssn[5..8]}" if member&.ssn
  end

  def formatted_submitted_at
    submitted_at&.in_time_zone("Mountain Time (US & Canada)")&.strftime("%D, %l:%M %p")
  end

  def formatted_birthday
    member.birthday.strftime("%D") if member&.birthday
  end

  def formatted_last_day
    last_day&.strftime("%D")
  end

  def formatted_last_paycheck
    last_paycheck&.strftime("%D")
  end
end
