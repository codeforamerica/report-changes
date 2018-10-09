require "rails_helper"

RSpec.feature "Demo site" do
  before do
    allow(Rails).to receive(:env) { "demo".inquiry }
  end

  scenario "applying" do
    visit "/"
    expect(page).to have_text "Report job changes"
    expect(page).to have_text "This site is for example purposes only."
    click_on "Start my report", match: :first

    expect(page).to have_text "Welcome! Here’s how reporting a change works"
    click_on "Start the form"

    expect(page).to have_text "Thanks for visiting the ReportChangesColorado example application!"
    click_on "Continue demo application"

    expect(page).to have_text "do you live in Arapahoe County?"
  end
end
