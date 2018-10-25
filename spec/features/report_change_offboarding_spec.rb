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

      expect(page).to have_text "What changed?"
      choose "I started a new job"
      click_on "Continue"

      expect(page).to have_text "Are you self-employed?"
      choose "I am self-employed"
      click_on "Continue"

      expect(current_path).to eq "/screens/not-yet-supported"
    end

    scenario "must wait until first paycheck" do
      visit "/"
      click_on "Start my report", match: :first

      expect(page).to have_text "Welcome! Here’s how reporting a change works"
      click_on "Start the form"

      expect(page).to have_text "do you live in Arapahoe County?"
      choose "Yes"
      click_on "Continue"

      expect(page).to have_text "What changed?"
      choose "I started a new job"
      click_on "Continue"

      expect(page).to have_text "Are you self-employed?"
      choose "I am not self-employed"
      click_on "Continue"

      expect(page).to have_text "Tell us about yourself."

      fill_in "What is your name?", with: "Jane Doe"
      fill_in "What is your phone number?", with: "555-222-3333"
      select "January", from: "form[birthday_month]"
      select "1", from: "form[birthday_day]"
      select 20.years.ago.year.to_s, from: "form[birthday_year]"
      click_on "Continue"

      expect(page).to have_text "Tell us about the new job."

      fill_in "What is the name of the company?", with: "Abc Corp"
      fill_in "What is the name of your supervisor or manager?", with: "My boss"
      fill_in "What is their phone number?", with: "999-888-7777"
      select "February", from: "form[first_day_month]"
      select "2", from: "form[first_day_day]"
      select "2018", from: "form[first_day_year]"
      choose "No"
      click_on "Continue"

      expect(page).to have_text("You should wait until you get your first paycheck to report this job.")
    end
  end
end
