require "rails_helper"

RSpec.feature "Report termination" do
  scenario "county not yet supported" do
    visit "/"
    click_on "Start my report", match: :first
    click_on "Start the form"
    choose "No"
    click_on "Continue"

    expect(page).to have_content "Sorry, you'll need to report your change a different way."
    expect(page).to have_content("Go to PEAK")
    expect(page).to have_content("Find my county office")
  end
end
