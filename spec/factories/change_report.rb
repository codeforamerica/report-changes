FactoryBot.define do
  factory :change_report do

    before(:create) do |change_report, evaluator|
      navigator = create :navigator
      member = create :member, navigator: navigator
      change_report.navigator = navigator
      change_report.member = member
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

      after(:create) do |change_report, evaluator|
        create(:change_report_metadata, change_report: change_report, consent_to_sms: evaluator.consent_to_sms)
      end
    end

    factory :change_report_with_letter, traits: %i[with_letter]
  end

end
