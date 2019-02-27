class ChangeDecorator < SimpleDelegator
  include ActionView::Helpers::NumberHelper

  def manager_phone_number
    decorate_phone_number(super)
  end

  def first_day
    super&.strftime("%D")
  end

  def last_day
    super&.strftime("%D")
  end

  def first_paycheck
    super&.strftime("%D")
  end

  def last_paycheck
    super&.strftime("%D")
  end

  def uploaded_proof
    documents&.attached? ? "yes" : "no"
  end

  def uploaded_proof_words_for_pdf
    documents&.attached? ? "See attached" : "Client does not have this"
  end

  def last_paycheck_amount
    number_to_currency(super)
  end

  def change_date
    super&.strftime("%D")
  end

  def hourly_wage
    "$#{super} /hr" if super.present?
  end

  def new_job_hours_a_week
    if same_hours_yes?
      same_hours_a_week_amount
    elsif same_hours_no?
      "#{lower_hours_a_week_amount} - #{upper_hours_a_week_amount}"
    end
  end

  def change_in_hours_hours_a_week
    if upper_hours_a_week_amount.present?
      "#{lower_hours_a_week_amount}-#{upper_hours_a_week_amount}"
    else
      lower_hours_a_week_amount
    end
  end

  def job_termination
    change_type_job_termination? ? "Yes" : "No"
  end

  def new_job
    change_type_new_job? ? "Yes" : "No"
  end

  def change_in_hours
    change_type_change_in_hours? ? "Yes" : "No"
  end

  def paid_yet
    not_unfilled(super)
  end

  def same_hours
    not_unfilled(super)
  end

  def ssn
    "#{member.ssn[0..2]}-#{member.ssn[3..4]}-#{member.ssn[5..8]}" if member&.ssn.present?
  end

  def birthday
    member&.birthday&.strftime("%D")
  end

  def client_name
    member&.full_name
  end

  def client_phone_number
    decorate_phone_number(member.phone_number)
  end

  private

  def decorate_phone_number(phone_number)
    if phone_number.present?
      "#{phone_number[0..2]}-#{phone_number[3..5]}-#{phone_number[6..9]}"
    else
      "no response"
    end
  end

  def not_unfilled(method)
    method == "unfilled" ? nil : method
  end
end
