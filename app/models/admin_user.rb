class AdminUser < ApplicationRecord
  devise :otp_authenticatable, :database_authenticatable,
         :recoverable, :rememberable, :validatable, :trackable,
         :timeoutable, :lockable

  def active_for_authentication?
    super && (last_sign_in_at.nil? || last_sign_in_at > 90.days.ago)
  end

  def inactive_message
    "It's been over 90 days since you last logged in, contact an admin to regain access."
  end
end
