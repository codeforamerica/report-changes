require "rails_helper"

feature "Report termination without letter" do
  before do
    visit "/"
    click_on "Start my report", match: :first
    click_on "Start the form"
    choose "Yes"
    click_on "Continue"
  end

  scenario "gather employer contact info" do
    visit do_you_have_a_letter_screens_path

    choose "No, I don't have this"
    click_on "Continue"

    expect(page).to have_content "May we send you text messages"
  end
end
