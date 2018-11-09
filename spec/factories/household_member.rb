FactoryBot.define do
  factory :household_member do
    change_report

    first_name { "Frank" }
    last_name { "Sinatra" }
  end
end
