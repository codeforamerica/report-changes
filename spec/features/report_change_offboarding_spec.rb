require "rails_helper"

RSpec.feature "Report change" do
  scenario "county not yet supported" do
    visit "/"
    click_on "Start my report", match: :first
    click_on "Start the form"

    fill_in "What's your zip code in Colorado?", with: "00000"
    click_on "Continue"

    expect(page).to have_content "Sorry, you'll need to report this change a different way."
    expect(page).to have_content("Go to PEAK")
    expect(page).to have_content("Find my county office")
  end

  scenario "overlapping zip used, county not yet supported" do
    visit "/"
    click_on "Start my report", match: :first
    click_on "Start the form"

    fill_in "What's your zip code in Colorado?", with: "80016"
    click_on "Continue"

    expect(page).to have_content "Your zip code exists in more than one county."
    choose "Douglas County"
    click_on "Continue"

    expect(page).to have_content "Sorry, you'll need to report this change a different way."
    expect(page).to have_content("Go to PEAK")
    expect(page).to have_content("Find my county office")
  end

  scenario "overlapping zip, where none are supported" do
    visit "/"
    click_on "Start my report", match: :first
    click_on "Start the form"

    fill_in "What's your zip code in Colorado?", with: "80430"
    click_on "Continue"

    expect(page).to have_content "Sorry, you'll need to report this change a different way."
    expect(page).to have_content("Go to PEAK")
    expect(page).to have_content("Find my county office")
  end

  scenario "county not listed" do
    visit "/"
    click_on "Start my report", match: :first
    click_on "Start the form"

    click_on "Select your county instead"

    select "Not listed", from: "What's your county in Colorado?"
    click_on "Continue"

    expect(page).to have_content "Sorry, you'll need to report this change a different way."
    expect(page).to have_content("Go to PEAK")
    expect(page).to have_content("Find my county office")
  end

  scenario "self employment not supported" do
    visit "/"
    click_on "Start my report", match: :first

    expect(page).to have_text "Welcome! Here’s how reporting a change works"
    click_on "Start the form"

    fill_in "What's your zip code in Colorado?", with: "80046"
    click_on "Continue"

    expect(page).to have_text "What changed?"
    choose "A new job"
    click_on "Continue"

    expect(page).to have_text "Who had this change?"
    choose "Me"
    click_on "Continue"

    expect(page).to have_text "What is your name?"
    fill_in "What is your first name?", with: "Person"
    fill_in "What is your last name?", with: "McPeoples"
    fill_in "What is your phone number?", with: "555-222-3333"
    select "January", from: "form[birthday_month]"
    select "1", from: "form[birthday_day]"
    select 20.years.ago.year.to_s, from: "form[birthday_year]"
    click_on "Continue"

    expect(page).to have_text "Are you self-employed?"
    choose "I am self-employed"
    click_on "Continue"

    expect(current_path).to eq "/screens/not-yet-supported"
  end
end
