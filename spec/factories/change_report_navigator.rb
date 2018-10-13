FactoryBot.define do
  factory :change_report_navigator do
    source { "awesome-cbo" }

    trait :has_termination_letter do
      proof_types { ["termination_letter"] }
    end
  end
end
