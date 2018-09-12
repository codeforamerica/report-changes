require "rails_helper"

RSpec.feature "Change report" do
  scenario "form navigation" do
    visit sections_path

    expect(page).to have_content("Form Section Navigation")
  end
end
