FactoryBot.define do
  factory :change_report do
    trait :with_navigator do
      after(:create) do |change_report|
        create(:change_report_navigator, change_report: change_report)
      end
    end

    trait :with_member do
      after(:create) do |change_report|
        create(:household_member, birthday: 25.years.ago - 1.day, change_report: change_report)
      end
    end

    trait :with_letter do
      letters do
        [fixture_file_upload(Rails.root.join("spec", "fixtures", "image.jpg"), "image/jpg")]
      end
    end
  end
end
