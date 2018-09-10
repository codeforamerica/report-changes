require "rails_helper"

feature "Reporting a change" do
  scenario "job termination" do
    visit "/"
    expect(page).to have_text "Leave a job?"

    click_on "Start my report", match: :first
    expect(page).to have_text "Welcome! Here’s how reporting a change works"
  end
end
