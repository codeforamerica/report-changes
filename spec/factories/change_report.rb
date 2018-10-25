FactoryBot.define do
  factory :change_report do
    trait :with_navigator do
      transient do
        source { nil }
      end

      after(:create) do |change_report, evaluator|
        create(:change_report_navigator, change_report: change_report, source: evaluator.source)
      end
    end

    trait :with_member do
      transient do
        name { "Quincy Jones" }
      end

      after(:create) do |change_report, evaluator|
        create(:household_member, birthday: 25.years.ago - 1.day, change_report: change_report, name: evaluator.name)
      end
    end

    trait :job_termination do
      change_type { "job_termination" }
    end

    trait :new_job do
      change_type { "new_job" }
    end

    trait :with_letter do
      letters do
        [fixture_file_upload(Rails.root.join("spec", "fixtures", "image.jpg"), "image/jpg")]
      end
    end

    trait :signed do
      signature { "BoJack Horseman" }
    end

    factory :change_report_with_letter, traits: %i[with_navigator with_member with_letter]
  end
end
