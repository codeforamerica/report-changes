class HouseholdMember < ActiveRecord::Base
  belongs_to :change_report

  attribute :ssn
  attr_encrypted(
    :ssn,
    key: Rails.application.credentials[Rails.env.to_sym][:secret_key_for_ssn_encryption],
  )
end
