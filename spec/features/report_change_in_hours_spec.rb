require "rails_helper"

RSpec.feature "Reporting a change", :a11y, :js do
  scenario "change in hours" do
    visit "/"
    proceed_with "Start my report", match: :first

    expect(page).to have_text "Welcome! Here’s how reporting a change works"
    proceed_with "Start the form"

    expect(page).to have_text "do you live in Arapahoe County?"
    choose "Yes"
    proceed_with "Continue"

    expect(page).to have_text "Who had this change?"
    choose "Me"
    proceed_with "Continue"

    expect(page).to have_text "What is your name?"
    fill_in "What is your first name?", with: "Jane"
    fill_in "What is your last name?", with: "Doe"
    proceed_with "Continue"

    expect(page).to have_text "What changed?"
    check "My hours or pay changed"
    proceed_with "Continue"

    expect(page).to have_text "Tell us about yourself."

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

    expect(page).to have_text "Tell us about your change in hours or pay."

    fill_in "Lower amount", with: "25" # How many hours a week will you work?
    fill_in "What will your hourly wage be?", with: "15"
    select "February", from: "form[change_date_month]"
    select "21", from: "form[change_date_day]"
    select "2018", from: "form[change_date_year]"
    fill_in "How often do you get paid?", with: "Every two weeks"
    fill_in "Is there anything else we should know about your hours or wages at this job?", with: "Not really"
    proceed_with "Continue"

    expect(page).to have_text "Do you have a letter or paystubs?"
    choose "Yes"
    proceed_with "Continue"

    expect(page).to have_text "Add the letter or paystubs."
    page.attach_file("form[letters][]", Rails.root.join("spec", "fixtures", "image.jpg"), make_visible: true)
    expect(page).to have_text "image.jpg"
    proceed_with "Continue"

    expect(page).to have_text "May we contact you via text message"
    choose "Yes"
    proceed_with "Continue"

    expect(page).to have_text "Would you like a copy of this change report?"
    fill_in "What is your email address?", with: "fake@example.com"
    proceed_with "Continue"

    expect(page).to have_text "Type your name to sign your change report."
    fill_in "Type your full legal name", with: "Person McPeoples"
    proceed_with "Sign and submit"

    expect(page).to have_text "You have successfully submitted your change report"
    choose "Good", allow_label_click: true
    fill_in "Do you have any feedback for us?", with: "My feedback"
    proceed_with "Submit"

    expect(page).to have_content("Thanks for your feedback")
  end
end
