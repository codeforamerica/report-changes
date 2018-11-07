require "rails_helper"

RSpec.feature "Reporting a change", :a11y, :js do
  include ActiveJob::TestHelper

  context "when new job flow is enabled" do
    around do |example|
      ActionMailer::Base.deliveries.clear
      perform_enqueued_jobs do
        with_modified_env NEW_JOB_FLOW_ENABLED: "true" do
          example.run
        end
      end
    end

    scenario "change in hours" do
      visit "/"
      proceed_with "Start my report", match: :first

      expect(page).to have_text "Welcome! Here’s how reporting a change works"
      proceed_with "Start the form"

      expect(page).to have_text "do you live in Arapahoe County?"
      choose "Yes"
      proceed_with "Continue"

      expect(page).to have_text "What changed?"
      choose "My hours changed"
      proceed_with "Continue"

      expect(page).to have_text "Tell us about yourself."

      fill_in "What is your name?", with: "Jane Doe"
      fill_in "What is your phone number?", with: "555-222-3333"
      select "January", from: "form[birthday_month]"
      select "1", from: "form[birthday_day]"
      select 20.years.ago.year.to_s, from: "form[birthday_year]"
      proceed_with "Continue"

      expect(page).to have_text "Tell us about this job."

      fill_in "What is the name of the company?", with: "Abc Corp"
      fill_in "What is the name of someone from the company", with: "My boss"
      fill_in "What is their phone number?", with: "999-888-7777"
      proceed_with "Continue"

      expect(page).to have_text "Tell us about your change in hours."

      fill_in "Lower amount", with: "25" # How many hours a week will you work?
      select "February", from: "form[change_date_month]"
      select "21", from: "form[change_date_day]"
      select "2018", from: "form[change_date_year]"
      fill_in "What is your hourly wage?", with: "15"
      fill_in "How often do you get paid?", with: "Every two weeks"
      fill_in "Is there anything else we should know about your hours or wages at this job?", with: "Not really"
      proceed_with "Continue"

      expect(page).to have_text "Do you have proof of this change?"
      # expect(page).to have_text "A letter from your job"
      proceed_with "Continue"

      # expect(page).to have_text "What do you have?"
      # check "I have paystubs"
      # proceed_with "Continue"
      #
      # expect(page).to have_text "Add your paystubs."
      #
      # page.attach_file("form[letters][]", Rails.root.join("spec", "fixtures", "image.jpg"), make_visible: true)
      # expect(page).to have_text "image.jpg"
      # proceed_with "Continue"

      expect(page).to have_text "May we contact you via text message"
      choose "Yes"
      proceed_with "Continue"

      expect(page).to have_text "Sign your change report"
      fill_in "Type your full legal name", with: "Person McPeoples"
      proceed_with "Sign and submit"

      expect(page).to have_text "You have successfully submitted your change report"
      choose "Good", allow_label_click: true
      fill_in "Do you have any feedback for us?", with: "My feedback"
      proceed_with "Submit"

      expect(page).to have_content("Thanks for your feedback")

      emails = ActionMailer::Base.deliveries

      expect(emails.count).to eq 1
      expect(emails.last.attachments.count).to eq 1
    end
  end
end
