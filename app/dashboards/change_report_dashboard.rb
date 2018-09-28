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
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    case_number: Field::String,
    phone_number: Field::String,
    signature: Field::String,
    company_name: Field::String,
    company_address: Field::String,
    company_phone_number: Field::String,
    last_day: Field::DateTime,
    last_paycheck: Field::DateTime,
    signature_confirmation: Field::Enum.with_options(searchable: false),
    consent_to_sms: Field::Enum.with_options(searchable: false),
    feedback_rating: Field::Enum,
    feedback_comments: Field::Text,
    manager_name: Field::String,
    manager_phone_number: Field::String,
    manager_additional_information: Field::String,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i[
    id
    case_number
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
    id
    created_at
    updated_at
    case_number
    phone_number
    signature
    company_name
    company_address
    company_phone_number
    last_day
    last_paycheck
    signature_confirmation
    consent_to_sms
    feedback_rating
    feedback_comments
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
    company_address
    company_phone_number
    last_day
    last_paycheck
    signature_confirmation
    consent_to_sms
    feedback_rating
    feedback_comments
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
