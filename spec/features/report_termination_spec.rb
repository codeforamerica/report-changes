require "rails_helper"

feature "Reporting a chage" do
  scenario "the front page and all other pages have a clear notice of 'Demo' on there" do
    visit "/"
    expect(page).to have_text "Leave a job?"
  end
end
