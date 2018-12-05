require "administrate/base_dashboard"

class ChangeDashboard < Administrate::BaseDashboard
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
    change_type: Field::Enum,
    company_name: Field::String,
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
    same_hours: Field::Enum,
    same_hours_a_week_amount: Field::String,
    upper_hours_a_week_amount: Field::Number,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i[
    id
    change_type
    company_name
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
    id
    created_at
    updated_at
    change_type
    company_name
    first_day
    first_paycheck
    hourly_wage
    last_day
    last_paycheck
    last_paycheck_amount
    lower_hours_a_week_amount
    manager_additional_information
    manager_name
    manager_phone_number
    new_job_notes
    paid_how_often
    paid_yet
    same_hours
    same_hours_a_week_amount
    upper_hours_a_week_amount
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
  ].freeze

  # Overwrite this method to customize how change reports are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(change)
  #   "Change ##{change.id}"
  # end
end
