class ReportDecorator < SimpleDelegator
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

  def company_name
    reported_change&.company_name
  end

  def manager_additional_information
    reported_change&.manager_additional_information
  end

  def manager_name
    reported_change&.manager_name
  end

  def paid_how_often
    reported_change&.paid_how_often
  end

  def new_job_notes
    reported_change&.new_job_notes
  end

  def change_in_hours_notes
    reported_change&.change_in_hours_notes
  end

  def manager_phone_number
    format_phone_number(reported_change&.manager_phone_number)
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

  def last_day
    reported_change&.last_day&.strftime("%D")
  end

  def last_paycheck
    reported_change&.last_paycheck&.strftime("%D")
  end

  def client_name
    member&.full_name
  end

  def client_phone_number
    format_phone_number(phone_number)
  end

  def uploaded_proof
    letters.attached? ? "yes" : "no"
  end

  def uploaded_proof_words_for_pdf
    letters.attached? ? "See attached" : "Client does not have this"
  end

  def last_paycheck_amount
    number_to_currency(reported_change&.last_paycheck_amount)
  end

  def first_day
    reported_change&.first_day&.strftime("%D")
  end

  def change_date
    reported_change&.change_date&.strftime("%D")
  end

  def first_paycheck
    reported_change&.first_paycheck&.strftime("%D")
  end

  def hourly_wage
    "$#{reported_change.hourly_wage} /hr" if reported_change&.hourly_wage.present?
  end

  def hours_a_week
    if reported_change&.same_hours_yes?
      reported_change.same_hours_a_week_amount
    elsif reported_change&.same_hours_no?
      "#{reported_change.lower_hours_a_week_amount}-#{reported_change.upper_hours_a_week_amount}"
    end
  end

  def change_in_hours_hours_a_week
    if reported_change&.upper_hours_a_week_amount.present?
      "#{reported_change.lower_hours_a_week_amount}-#{reported_change.upper_hours_a_week_amount}"
    else
      reported_change&.lower_hours_a_week_amount
    end
  end

  def change_type_description
    case reported_change&.change_type
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
    reported_change&.change_type_new_job? ? reported_change&.paid_yet : ""
  end

  def same_hours
    reported_change&.change_type_new_job? ? reported_change&.same_hours : ""
  end

  private

  def format_phone_number(phone_number)
    if phone_number.present?
      "#{phone_number[0..2]}-#{phone_number[3..5]}-#{phone_number[6..9]}"
    end
  end
end
