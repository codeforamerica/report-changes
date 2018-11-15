require "administrate/base_dashboard"

class ChangeReportDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    case_number: Field::String,
    change_type: Field::Enum,
    company_name: Field::String,
    created_at: Field::DateTime,
    first_day: Field::DateTime,
    first_paycheck: Field::DateTime,
    hourly_wage: Field::String,
    last_day: Field::DateTime,
    last_paycheck: Field::DateTime,
    last_paycheck_amount: Field::Number,
    lower_hours_a_week_amount: Field::String,
    manager_additional_information: Field::String,
    manager_name: Field::String,
    manager_phone_number: Field::String,
    new_job_notes: Field::String,
    paid_how_often: Field::String,
    paid_yet: Field::Enum,
    phone_number: Field::String,
    same_hours: Field::Enum,
    same_hours_a_week_amount: Field::String,
    signature: Field::String,
    submitted_at: Field::DateTime,
    updated_at: Field::DateTime,
    upper_hours_a_week_amount: Field::Number,
    download_link: ChangeReportDownloadLinkField,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i[
    id
    change_type
    case_number
    signature
    submitted_at
    download_link
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
    id
    change_type
    created_at
    updated_at
    case_number
    signature
    phone_number
    company_name
    manager_name
    manager_phone_number
    manager_additional_information
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
    case_number
    phone_number
    signature
    company_name
    last_day
    last_paycheck
    manager_name
    manager_phone_number
    manager_additional_information
  ].freeze

  # Overwrite this method to customize how change reports are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(change_report)
  #   "ChangeReport ##{change_report.id}"
  # end
end
