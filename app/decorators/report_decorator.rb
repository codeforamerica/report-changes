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
      "signature",
      # job termination traits
      "job_termination",
      "job_termination_manager_additional_information",
      "job_termination_manager_phone_number",
      "last_day",
      "last_paycheck",
      "last_paycheck_amount",
      "job_termination_uploaded_proof",
      # new job traits
      "new_job",
      "new_job_manager_name",
      "new_job_manager_additional_information",
      "new_job_manager_phone_number",
      "new_job_hourly_wage",
      "new_job_paid_how_often",
      "new_job_notes",
      "first_day",
      "paid_yet",
      "first_paycheck",
      "same_hours",
      "hours_a_week",
      "new_job_uploaded_proof",
      # change in hours traits
      "change_in_hours",
      "change_in_hours_manager_name",
      "change_in_hours_manager_additional_information",
      "change_in_hours_manager_phone_number",
      "change_in_hours_hourly_wage",
      "change_in_hours_paid_how_often",
      "change_date",
      "change_in_hours_hours_a_week",
      "change_in_hours_notes",
      "change_in_hours_uploaded_proof",
    ]
  end

  def job_termination_manager_phone_number
    format_phone_number(job_termination_change&.manager_phone_number)
  end

  def new_job_manager_phone_number
    format_phone_number(new_job_change&.manager_phone_number)
  end

  def change_in_hours_manager_phone_number
    format_phone_number(change_in_hours_change&.manager_phone_number)
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
    job_termination_change&.last_day&.strftime("%D")
  end

  def last_paycheck
    job_termination_change&.last_paycheck&.strftime("%D")
  end

  def client_name
    member&.full_name
  end

  def client_phone_number
    format_phone_number(phone_number)
  end

  def job_termination_uploaded_proof
    job_termination_change&.documents&.attached? ? "yes" : "no"
  end

  def new_job_uploaded_proof
    new_job_change&.documents&.attached? ? "yes" : "no"
  end

  def change_in_hours_uploaded_proof
    change_in_hours_change&.documents&.attached? ? "yes" : "no"
  end

  def job_termination_uploaded_proof_words_for_pdf
    job_termination_change&.documents&.attached? ? "See attached" : "Client does not have this"
  end

  def new_job_uploaded_proof_words_for_pdf
    new_job_change&.documents&.attached? ? "See attached" : "Client does not have this"
  end

  def change_in_hours_uploaded_proof_words_for_pdf
    change_in_hours_change&.documents&.attached? ? "See attached" : "Client does not have this"
  end

  def last_paycheck_amount
    number_to_currency(job_termination_change&.last_paycheck_amount)
  end

  def first_day
    new_job_change&.first_day&.strftime("%D")
  end

  def change_date
    change_in_hours_change&.change_date&.strftime("%D")
  end

  def first_paycheck
    new_job_change&.first_paycheck&.strftime("%D")
  end

  def job_termination
    job_termination_change.present? ? "Yes" : "No"
  end

  def new_job
    new_job_change.present? ? "Yes" : "No"
  end

  def change_in_hours
    change_in_hours_change.present? ? "Yes" : "No"
  end

  def paid_yet
    new_job_change&.paid_yet || ""
  end

  def same_hours
    new_job_change&.same_hours || ""
  end

  private

  def format_phone_number(phone_number)
    if phone_number.present?
      "#{phone_number[0..2]}-#{phone_number[3..5]}-#{phone_number[6..9]}"
    end
  end
end
