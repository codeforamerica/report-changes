require "rails_helper"

RSpec.feature "Reporting a change" do
  context "when new job flow is enabled" do
    around do |example|
      with_modified_env NEW_JOB_FLOW_ENABLED: "true" do
        example.run
      end
    end

    scenario "new job" do
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

      expect(page).to have_text "Tell us about how much you will make at this job."

      fill_in "What is your hourly wage?", with: "15"
      choose "Yes" # same number of hours
      fill_in "How many hours a week will you work?", with: "25"
      fill_in "How often do you get paid?", with: "Every two weeks"
      select "February", from: "form[first_paycheck_month]"
      select "21", from: "form[first_paycheck_day]"
      select "2018", from: "form[first_paycheck_year]"
      fill_in "Is there anything else we should know about your hours or wages at this job?", with: "Not really"
      click_on "Continue"

      expect(page).to have_text "May we contact you via text message"
      choose "Yes"

      click_on "Continue"

      expect(page).to have_text "Sign your change report"
      fill_in "Type your full legal name", with: "Person McPeoples"
      click_on "Sign and submit"

      expect(page).to have_text "You have successfully submitted your change report"
      choose "Good", allow_label_click: true
      fill_in "Do you have any feedback for us?", with: "My feedback"
      click_on "Submit"

      expect(page).to have_content("Thanks for your feedback")
    end
  end
end
