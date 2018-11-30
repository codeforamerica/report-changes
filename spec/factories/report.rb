FactoryBot.define do
  factory :report do
    trait :with_navigator do
      transient do
        source { nil }
      end

      after(:create) do |report, evaluator|
        create(:navigator, report: report, source: evaluator.source)
      end
    end

    trait :with_member do
      transient do
        first_name { "Quincy" }
        last_name { "Jones" }
      end

      after(:create) do |report, evaluator|
        create(:household_member,
               birthday: 25.years.ago - 1.day,
               first_name: evaluator.first_name,
               last_name: evaluator.last_name,
               report: report)
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

    trait :with_metadata do
      transient do
        consent_to_sms { nil }
      end

      after(:create) do |report, evaluator|
        create(:report_metadata, report: report, consent_to_sms: evaluator.consent_to_sms)
      end
    end

    factory :report_with_letter, traits: %i[with_navigator with_member with_letter]
  end
end