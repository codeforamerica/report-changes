require "rails_helper"

RSpec.feature "Change report" do
  scenario "form navigation" do
    visit screens_path

    expect(page).to have_content("All of the screens!")
  end
end
