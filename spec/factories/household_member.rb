FactoryBot.define do
  factory :household_member, aliases: [:member] do
    first_name { "Frank" }
    last_name { "Sinatra" }


    trait :with_change_report do
      after(:create) do |member|
        create(:change_report, member: member)
      end
    end
  end
end
