require "rails_helper"

RSpec.feature "Demo site" do
  around do |example|
    with_modified_env DEMO_MODE: "true" do
      example.run
    end
  end

  scenario "applying" do
    visit "/"
    expect(page).to have_text "This site is for example purposes only."
    click_on "Start my report", match: :first

    expect(page).to have_text "Welcome! Here’s how reporting a change works"
    click_on "Start the form"

    expect(page).to have_text "Thanks for visiting the ReportChangesColorado example tool!"
    click_on "Continue demo"

    expect(page).to have_text "What's your zip code in Colorado?"
  end
end
