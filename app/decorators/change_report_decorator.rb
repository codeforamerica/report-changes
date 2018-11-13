class ChangeReportDecorator < SimpleDelegator
  include ActionView::Helpers::NumberHelper

  def self.header_attributes
    [
      "change_type_description",
      "submitted_at",
      "case_number",
      "client_name",
      "birthday",
      "ssn",
      "client_phone_number",
      "company_name",
      "last_day",
      "last_paycheck",
      "last_paycheck_amount",
      "manager_name",
      "manager_phone_number",
      "manager_additional_information",
      "uploaded_proof",
      "signature",
      "first_day",
      "paid_yet",
      "first_paycheck",
      "hourly_wage",
      "same_hours",
      "hours_a_week",
      "paid_how_often",
      "new_job_notes",
      "change_date",
      "change_in_hours_hours_a_week",
      "change_in_hours_notes",
    ]
  end

  def manager_name
    super.present? ? super : "no response"
  end

  def manager_phone_number
    if super.present?
      format_phone_number(super)
    else
      "no response"
    end
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
    member&.full_name
  end

  def client_phone_number
    format_phone_number(phone_number)
  end

  def case_number
    super.present? ? super : "no response"
  end

  def uploaded_proof
    letters.attached? ? "yes" : "no"
  end

  def termination_verification
    navigator.has_termination_letter_yes? ? "See attached" : "Client does not have this"
  end

  def last_paycheck_amount
    if super.present?
      number_to_currency(super)
    else
      "no response"
    end
  end

  def first_day
    super&.strftime("%D")
  end

  def change_date
    super&.strftime("%D")
  end

  def first_paycheck
    super&.strftime("%D")
  end

  def hourly_wage
    "$#{super} /hr" if super.present?
  end

  def hours_a_week
    if same_hours_yes?
      same_hours_a_week_amount
    elsif same_hours_no?
      "#{lower_hours_a_week_amount}-#{upper_hours_a_week_amount}"
    end
  end

  def change_in_hours_hours_a_week
    if upper_hours_a_week_amount.present?
      "#{lower_hours_a_week_amount}-#{upper_hours_a_week_amount}"
    else
      lower_hours_a_week_amount
    end
  end

  def uploaded_new_job_verification
    letters.attached? ? "Yes" : "Neither"
  end

  def change_type_description
    case change_type
    when "job_termination"
      "Income change: job termination"
    when "new_job"
      "Income change: new job"
    when "change_in_hours"
      "Income change: change in hours"
    else
      ""
    end
  end

  def paid_yet
    change_type_new_job? ? super : ""
  end

  def same_hours
    change_type_new_job? ? super : ""
  end

  private

  def format_phone_number(phone_number)
    if phone_number
      "#{phone_number[0..2]}-#{phone_number[3..5]}-#{phone_number[6..9]}"
    end
  end
end
