require "rails_helper"

RSpec.feature "Delayed job overview" do
  before do
    user = create(:admin_user)
    login_as(user)
  end

  scenario "can view the delayed job page when logged in" do
    visit "/admin/delayed_job"

    expect(page).to have_content("The list below shows an overview of the jobs in the delayed_job queue.")
  end
end
