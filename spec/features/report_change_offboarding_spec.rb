require "rails_helper"

RSpec.feature "Report change" do
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

  context "when new job flow is enabled" do
    around do |example|
      with_modified_env NEW_JOB_FLOW_ENABLED: "true" do
        example.run
      end
    end

    scenario "self employment not supported" do
      visit "/"
      click_on "Start my report", match: :first

      expect(page).to have_text "Welcome! Here’s how reporting a change works"
      click_on "Start the form"

      expect(page).to have_text "do you live in Arapahoe County?"
      choose "Yes"
      click_on "Continue"

      expect(page).to have_text "Who had this change?"
      choose "Myself"
      click_on "Continue"

      expect(page).to have_text "What is your name?"
      fill_in "What is your first name?", with: "Person"
      fill_in "What is your last name?", with: "McPeoples"
      click_on "Continue"

      expect(page).to have_text "What changed?"
      choose "I started a new job"
      click_on "Continue"

      expect(page).to have_text "Are you self-employed?"
      choose "I am self-employed"
      click_on "Continue"

      expect(current_path).to eq "/screens/not-yet-supported"
    end
  end
end
