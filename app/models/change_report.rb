class ChangeReport < ActiveRecord::Base
  has_one :navigator,
          class_name: "ChangeReportNavigator",
          foreign_key: "change_report_id",
          dependent: :destroy

  has_one :member,
           class_name: "HouseholdMember",
           foreign_key: "change_report_id",
           dependent: :destroy

  enum signature_confirmation: { unfilled: 0, confirmed: 1 }
end
