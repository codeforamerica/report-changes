FactoryBot.define do
  factory :report do
    trait :with_navigator do
      transient do
        source { nil }
        has_new_job_documents { nil }
      end

      after(:create) do |report, evaluator|
        create(:navigator,
               report: report,
               source: evaluator.source,
               has_new_job_documents: evaluator.has_new_job_documents)
      end
    end

    trait :with_member do
      transient do
        first_name { "Quincy" }
        last_name { "Jones" }
      end

      after(:create) do |report, evaluator|
        create(:member,
               birthday: 25.years.ago - 1.day,
               first_name: evaluator.first_name,
               last_name: evaluator.last_name,
               report: report)
      end
    end

    trait :with_change do
      transient do
        change_type { "job_termination" }
        documents { [] }
      end

      after(:create) do |report, evaluator|
        create(:change,
          change_type: evaluator.change_type,
          report: report,
          documents: evaluator.documents)
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

    factory :report_with_letter, traits: %i[with_navigator with_member]
  end
end
