class ChangeReportDecorator < SimpleDelegator
  def self.header_attributes
    [
      "submitted_at",
      "case_number",
      "client_name",
      "birthday",
      "ssn",
      "client_phone_number",
      "company_name",
      "last_day",
      "last_paycheck",
      "manager_name",
      "manager_phone_number",
      "manager_additional_information",
      "uploaded_proof",
    ]
  end

  def manager_phone_number
    format_phone_number(super)
  end

  def ssn
    if member&.ssn.present?
      "#{member.ssn[0..2]}-#{member.ssn[3..4]}-#{member.ssn[5..8]}"
    else
      "no response"
    end
  end

  def submitted_at
    super&.in_time_zone("Mountain Time (US & Canada)")&.strftime("%D, %l:%M %p")
  end

  def birthday
    member.birthday.strftime("%D") if member&.birthday
  end

  def last_day
    super&.strftime("%D")
  end

  def last_paycheck
    super&.strftime("%D")
  end

  def client_name
    member&.name
  end

  def client_phone_number
    format_phone_number(phone_number)
  end

  def case_number
    super || "no response"
  end

  def uploaded_proof
    letters.attached? ? "yes" : "no"
  end

  def termination_letter
    navigator.has_letter_yes? ? "See attached" : "Client does not have this"
  end

  private

  def format_phone_number(phone_number)
    if phone_number
      "#{phone_number[0..2]}-#{phone_number[3..5]}-#{phone_number[6..9]}"
    end
  end
end
