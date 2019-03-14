require "rails_helper"

feature "Reporting a change", :a11y, :js do
  include ActiveJob::TestHelper

  around do |example|
    FakeSmsClient.clear
    ActionMailer::Base.deliveries.clear
    perform_enqueued_jobs do
      example.run
    end
  end

  scenario "job termination" do
    visit "/"
    expect(page).to have_text "Report changes to your benefits case"
    expect(page).to have_title "Report changes to your Colorado benefits case"
    proceed_with "Start my report", match: :first

    expect(page).to have_text "Welcome! Here’s how reporting a change works"
    expect(page).to have_title "Welcome! Here’s how reporting a change works: | ReportChangesColorado.org"
    proceed_with "Start the form"

    fill_in "What's your zip code in Colorado?", with: "80046"
    proceed_with "Continue"

    expect(page).to have_text "What changed?"
    choose "A job ended or someone stopped working"
    proceed_with "Continue"

    expect(page).to have_text "Who had this change?"
    choose "Me"
    proceed_with "Continue"

    expect(page).to have_text "What is your name?"
    fill_in "What is your first name?", with: "Jane"
    fill_in "What is your last name?", with: "Doe"
    fill_in "What is your phone number?", with: "555-222-3333"
    select "January", from: "form[birthday_month]"
    select "1", from: "form[birthday_day]"
    select 20.years.ago.year.to_s, from: "form[birthday_year]"
    proceed_with "Continue"

    expect(page).to have_text "Tell us about the job that ended"

    fill_in "What is the name of the company?", with: "Abc Corp"
    fill_in "What is the name of someone from the company who can verify your employment?", with: "My boss"
    fill_in "What is their phone number?", with: "999-888-7777"
    proceed_with "Continue"

    expect(page).to have_text "Tell us more about the job that ended"
    select "February", from: "form[last_day_month]"
    select "2", from: "form[last_day_day]"
    select "2018", from: "form[last_day_year]"
    select "February", from: "form[last_paycheck_month]"
    select "12", from: "form[last_paycheck_day]"
    select "2018", from: "form[last_paycheck_year]"
    fill_in "What was the amount of your final paystub, pre-tax?", with: "127.14"
    proceed_with "Continue"

    expect(page).to have_text "Do you have a letter or paystubs?"
    choose "Yes"
    proceed_with "Continue"

    expect(page).to have_text "Add the letter or paystubs."
    page.attach_file("form[documents][]", Rails.root.join("spec", "fixtures", "image.jpg"), make_visible: true)
    expect(page).to have_text "image.jpg"
    proceed_with "Continue"

    expect(page).to have_text "Do you have any other changes to report?"
    choose "No"
    proceed_with "Continue"

    expect(page).to have_text "May we contact you via text message"
    expect(page).to have_text "We'll send text messages to (555) 222-3333"
    choose "Yes"
    proceed_with "Continue"

    expect(page).to have_text "Would you like a copy of this change report?"
    fill_in "What is your email address?", with: "fake@example.com"
    proceed_with "Continue"

    expect(page).to have_text "Type your name to sign this change report."
    fill_in "Type your full legal name", with: "Jane Doe"
    proceed_with "Sign and submit"

    expect(page).to have_text "You have successfully submitted this change report"
    choose "Good", allow_label_click: true
    fill_in "Do you have any feedback for us?", with: "My feedback"
    proceed_with "Submit"

    expect(page).to have_content("Thanks for your feedback")

    text_messages = FakeSmsClient.sent_messages

    expect(text_messages.count).to eq(1)
    expect(text_messages.first.message).to include("Your change report has been submitted to your county")

    emails = ActionMailer::Base.deliveries

    expect(emails.count).to eq 2
    expect(emails.last.attachments.count).to eq 1
  end
end
