FactoryBot.define do
  factory :change do
    trait :job_termination do
      change_type { "job_termination" }
    end

    trait :new_job do
      change_type { "new_job" }
    end

    trait :change_in_hours do
      change_type { "change_in_hours" }
    end
  end
end
