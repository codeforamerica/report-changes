require "rails_helper"

RSpec.feature "Pre-launch" do
  around do |example|
    with_modified_env PRE_LAUNCH_ENABLED: "true" do
      example.run
    end
  end

  scenario "applying" do
    visit "/"
    expect(page).to have_text "Coming soon"
    expect(page).to have_button("Start my report", disabled: true)
    expect(page).not_to have_link("Start my report")
  end
end
