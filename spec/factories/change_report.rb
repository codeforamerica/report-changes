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
        first_name { "Quincy" }
        last_name { "Jones" }
      end

      after(:create) do |change_report, evaluator|
        create(:household_member,
               birthday: 25.years.ago - 1.day,
               first_name: evaluator.first_name,
               last_name: evaluator.last_name,
               change_report: change_report)
      end
    end

    trait :job_termination do
      change_type { "job_termination" }
    end

    trait :new_job do
      change_type { "new_job" }
    end

    trait :change_in_hours do
      change_type { "change_in_hours" }
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
