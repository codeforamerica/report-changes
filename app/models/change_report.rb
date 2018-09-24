class ChangeReport < ActiveRecord::Base
  has_one :navigator,
          class_name: "ChangeReportNavigator",
          foreign_key: "change_report_id",
          dependent: :destroy

  has_one :member,
           class_name: "HouseholdMember",
           foreign_key: "change_report_id",
           dependent: :destroy

  has_many_attached :letters

  enum signature_confirmation: { unfilled: 0, yes: 1 }, _prefix: :confirmed_signature
  enum consent_to_sms: { unfilled: 0, yes: 1, no: 2 }, _prefix: :consented_to_sms
end
