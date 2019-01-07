require "rails_helper"

RSpec.feature "Reporting a change", :a11y, :js do
  include ActiveJob::TestHelper

  around do |example|
    ActionMailer::Base.deliveries.clear
    perform_enqueued_jobs do
      example.run
    end
  end

  scenario "new job" do
    visit "/"
    proceed_with "Start my report", match: :first

    expect(page).to have_text "Welcome! Here’s how reporting a change works"
    proceed_with "Start the form"

    expect(page).to have_text "do you live in Arapahoe County?"
    choose "Yes"
    proceed_with "Continue"

    expect(page).to have_text "Who had this change?"
    choose "Someone in my household"
    proceed_with "Continue"

    expect(page).to have_text "Who are you reporting this change for?"
    fill_in "What is their first name?", with: "Jane"
    fill_in "What is their last name?", with: "Doe"
    proceed_with "Continue"

    expect(page).to have_text "What changed?"
    check "They started a new job"
    proceed_with "Continue"

    expect(page).to have_text "Tell us about Jane."
    fill_in "What is their phone number?", with: "555-222-3333"
    select "January", from: "form[birthday_month]"
    select "1", from: "form[birthday_day]"
    select 20.years.ago.year.to_s, from: "form[birthday_year]"
    proceed_with "Continue"

    expect(page).to have_text "Is Jane self-employed?"
    choose "They are not self-employed"
    proceed_with "Continue"

    expect(page).to have_text "Tell us about the new job."

    fill_in "What is the name of the company?", with: "Abc Corp"
    fill_in "What is the name of Jane's supervisor or manager?", with: "My boss"
    fill_in "What is this person's phone number?", with: "999-888-7777"
    proceed_with "Continue"

    expect(page).to have_text "Tell us more about the new job."
    select "February", from: "form[first_day_month]"
    select "2", from: "form[first_day_day]"
    select Time.now.year, from: "form[first_day_year]"
    choose "Yes" # Have they been paid yet?
    proceed_with "Continue"

    expect(page).to have_text "Tell us about how much Jane will make at this job."

    fill_in "What is their hourly wage?", with: "15"
    choose "Yes" # same number of hours
    fill_in "How many hours a week will they work?", with: "25"
    fill_in "How often do they get paid?", with: "Every two weeks"
    select "February", from: "form[first_paycheck_month]"
    select "21", from: "form[first_paycheck_day]"
    select Time.now.year, from: "form[first_paycheck_year]"
    fill_in "Is there anything else we should know about Jane's hours or wages at this job?", with: "Not really"
    proceed_with "Continue"

    expect(page).to have_text "Do you have a letter or paystubs?"
    choose "Yes"
    proceed_with "Continue"

    expect(page).to have_text "Add the letter or paystubs."
    page.attach_file("form[letters][]", Rails.root.join("spec", "fixtures", "image.jpg"), make_visible: true)
    expect(page).to have_text "image.jpg"
    proceed_with "Continue"

    expect(page).to have_text "Sign this change report"
    fill_in "Type your full legal name", with: "Person McPeoples"
    proceed_with "Sign and submit"

    expect(page).to have_text "You have successfully submitted this change report"
    choose "Good", allow_label_click: true
    fill_in "Do you have any feedback for us?", with: "My feedback"
    proceed_with "Submit"

    expect(page).to have_content("Thanks for your feedback")

    emails = ActionMailer::Base.deliveries

    expect(emails.count).to eq 1
    expect(emails.last.attachments.count).to eq 1
  end
end
