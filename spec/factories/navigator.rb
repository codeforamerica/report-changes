FactoryBot.define do
  factory :navigator do
    selected_county_location { "arapahoe" }
    is_self_employed { "no" }
    source { "awesome-cbo" }
  end
end
