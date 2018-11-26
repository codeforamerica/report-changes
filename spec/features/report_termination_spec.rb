require "rails_helper"

feature "Reporting a change", :a11y, :js do
  include ActiveJob::TestHelper

  around do |example|
    ActionMailer::Base.deliveries.clear
    perform_enqueued_jobs do
      example.run
    end
  end

  scenario "job termination" do
    visit "/"
    expect(page).to have_text "Report the change"
    expect(page).to have_title "ReportChangesColorado.org"
    proceed_with "Start my report", match: :first

    expect(page).to have_text "Welcome! Here’s how reporting a change works"
    expect(page).to have_title "Welcome! Here’s how reporting a change works: | ReportChangesColorado.org"
    proceed_with "Start the form"

    expect(page).to have_text "do you live in Arapahoe County?"
    choose "I'm not sure"
    proceed_with "Continue"

    expect(page).to have_text "Where do you live?"
    fill_in "Street address", with: "1355 South Laredo Court"
    fill_in "City", with: "Aurora"
    fill_in "Zip code", with: "80017"
    proceed_with "Continue"

    expect(page).to have_text "Great, it looks like you live in Arapahoe County."
    proceed_with "Continue"

    expect(page).to have_text "Who had this change?"
    choose "Me"
    proceed_with "Continue"

    expect(page).to have_text "What is your name?"
    fill_in "What is your first name?", with: "Jane"
    fill_in "What is your last name?", with: "Doe"
    proceed_with "Continue"

    expect(page).to have_text "What changed?"
    choose "My job ended or I stopped working"
    proceed_with "Continue"

    expect(page).to have_text "Tell us about yourself."
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
    page.attach_file("form[letters][]", Rails.root.join("spec", "fixtures", "image.jpg"), make_visible: true)
    expect(page).to have_text "image.jpg"
    proceed_with "Continue"

    expect(page).to have_text "May we contact you via text message"
    expect(page).to have_text "We'll send text messages to (555) 222-3333"
    choose "Yes"

    proceed_with "Continue"

    expect(page).to have_text "Sign your change report"
    fill_in "Type your full legal name", with: "Jane Doe"
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
