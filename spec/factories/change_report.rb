FactoryBot.define do
  factory :change_report do
    trait :with_navigator do
      after(:create) do |change_report|
        create(:change_report_navigator, change_report: change_report)
      end
    end
  end
end
