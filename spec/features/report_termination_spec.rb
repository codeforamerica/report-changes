require "rails_helper"

feature "Reporting a change" do
  scenario "job termination" do
    visit "/"
    expect(page).to have_text "Leave a job?"

    click_on "Start my report", match: :first
    expect(page).to have_text "Welcome! Here’s how reporting a change works"

    click_on "Start the form"
    expect(page).to have_text "do you live in Arapahoe County?"

    choose "I'm not sure"
    click_on "Continue"

    expect(page).to have_text "Where do you live?"

    fill_in "Street address", with: "1355 South Laredo Court"
    fill_in "City", with: "Aurora"
    fill_in "Zip code", with: "80017"
    click_on "Continue"
    expect(page).to have_text "Great, it looks like you live in Arapahoe County."

    click_on "Continue"
    expect(page).to have_text "Tell us about yourself."

    fill_in "What is your name?", with: "Jane Doe"
    fill_in "What is your phone number?", with: "111-222-3333"
    fill_in "What is your social security number?", with: "111-22-3333"
    select "January", from: "form[birthday_month]"
    select "1", from: "form[birthday_day]"
    select "2000", from: "form[birthday_year]"
    click_on "Continue"
    expect(page).to have_text "Success"
  end
end
