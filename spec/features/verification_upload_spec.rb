require "rails_helper"

feature "Uploading verifications", js: true do
  before do
    visit "/"
    click_on "Start my report", match: :first
    click_on "Start the form"
    choose "Yes"
    click_on "Continue"
  end

  scenario "add letters" do
    visit add_letter_screens_path

    page.attach_file("form[letters][]", Rails.root.join("spec", "fixtures", "image.jpg"), make_visible: true)
    expect(page).to have_text "image.jpg"

    click_on "Continue"

    expect(page).to_not have_text "Add your letter."

    visit add_letter_screens_path
    expect(page).to have_text "image.jpg"

    click_on "Continue"

    expect(page).to_not have_text "Add your letter."
  end

  scenario "delete letters" do
    visit add_letter_screens_path

    page.attach_file("form[letters][]", Rails.root.join("spec", "fixtures", "image.jpg"), make_visible: true)
    expect(page).to have_text "image.jpg"

    click_on "Delete"
    expect(page).to_not have_text "image.jpg"
    click_on "Continue"

    visit add_letter_screens_path
    expect(page).to_not have_text "image.jpg"

    page.attach_file("form[letters][]", Rails.root.join("spec", "fixtures", "image.jpg"), make_visible: true)
    expect(page).to have_text "image.jpg"

    click_on "Continue"
    visit add_letter_screens_path
    expect(page).to have_text "image.jpg"
    click_on "Delete"

    expect(page).to_not have_text "image.jpg"
  end
end
