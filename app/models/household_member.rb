class HouseholdMember < ActiveRecord::Base
  belongs_to :change_report

  attribute :ssn
  attr_encrypted(
    :ssn,
    key: CredentialsHelper.secret_key_for_ssn_encryption,
  )

  def age
    time_delta = Time.zone.now - birthday.to_datetime
    (time_delta / 1.years).to_int
  end

  def full_name
    "#{first_name} #{last_name}"
  end
end
