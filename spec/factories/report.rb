FactoryBot.define do
  factory :report do
    transient do
      change_type { "job_termination" }
    end

    trait :filled do
      after(:create) do |report, evaluator|
        member = create :member, report: report
        change = create :change, member: member, change_type: evaluator.change_type
        create :navigator, report: report, current_member: member, current_change: change
        create :report_metadata, report: report
        create :change_navigator, change: change
      end
    end
  end
end
