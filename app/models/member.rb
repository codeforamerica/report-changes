class Member < ActiveRecord::Base
  belongs_to :report

  attribute :ssn
  attr_encrypted(
    :ssn,
    key: CredentialsHelper.secret_key_for_ssn_encryption,
  )

  def age
    if birthday
      time_delta = Time.zone.now - birthday.to_datetime
      (time_delta / 1.years).to_int
    end
  end

  def full_name
    [first_name, last_name].compact.join(" ")
  end
end
