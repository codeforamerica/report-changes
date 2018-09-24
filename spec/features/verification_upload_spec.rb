require "rails_helper"

feature "Uploading verifications", js: true do
  scenario "add letters" do
    visit "/"
    click_on "Start my report", match: :first
    click_on "Start the form"
    choose "Yes"
    click_on "Continue"

    visit add_letter_screens_path

    page.attach_file("form[letters][]", Rails.root.join("spec", "fixtures", "image.jpg"), make_visible: true)
    expect(page).to have_text "image.jpg"

    click_on "Continue"

    visit add_letter_screens_path
    expect(page).to have_text "image.jpg"
  end
end
