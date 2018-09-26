require "rails_helper"

RSpec.feature "Admin viewing dashboard" do
  before do
    user = create(:admin_user)
    login_as(user)
  end

  scenario "viewing details for a change_report" do
    change_report = create(:change_report)

    visit admin_root_path

    expect(page).to have_content("Change Report")

    click_on change_report.id

    expect(page).to have_content("ChangeReport ##{change_report.id}")
  end

  scenario "searching isn't broken", js: true do
    visit admin_root_path(search: "asdf")

    expect(page).to have_content("Change Report")
  end
end
