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

    fill_in "Street address", with: "123 Main St"
    fill_in "City", with: "Littleton"
    fill_in "Zip code", with: "80110"
    click_on "Continue"

    expect(page).to have_text "Success"
  end
end
