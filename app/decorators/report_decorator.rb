class ReportDecorator < SimpleDelegator
  include ActionView::Helpers::NumberHelper

  def self.header_attributes
    [
      "submitted_at",
      "case_number",
      "client_name",
      "birthday",
      "ssn",
      "client_phone_number",
      "client_name",
      "signature",
    ]
  end

  def ssn
    "#{member.ssn[0..2]}-#{member.ssn[3..4]}-#{member.ssn[5..8]}" if member&.ssn.present?
  end

  def submitted_at
    super&.in_time_zone("Mountain Time (US & Canada)")&.strftime("%D, %l:%M %p")
  end

  def birthday
    member&.birthday&.strftime("%D")
  end

  def client_name
    member&.full_name
  end

  def client_phone_number
    format_phone_number(phone_number)
  end

  private

  def format_phone_number(phone_number)
    if phone_number.present?
      "#{phone_number[0..2]}-#{phone_number[3..5]}-#{phone_number[6..9]}"
    end
  end
end
