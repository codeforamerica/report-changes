require "rails_helper"

feature "Uploading verifications", js: true do
  before do
    visit "/"
    expect(page).to have_text "Report changes to your benefits case"
    expect(page).to have_title "ReportChangesColorado.org"
    click_on "Start my report", match: :first

    expect(page).to have_text "Welcome! Here’s how reporting a change works"
    click_on "Start the form"

    expect(page).to have_text "do you live in Arapahoe County?"
    choose "Yes"
    click_on "Continue"

    expect(page).to have_text "Who had this change?"
    choose "Me"
    click_on "Continue"

    expect(page).to have_text "What is your name?"
    fill_in "What is your first name?", with: "Jane"
    fill_in "What is your last name?", with: "Doe"
    click_on "Continue"

    expect(page).to have_text "What changed?"
    choose "My hours or pay changed"
    proceed_with "Continue"
  end

  scenario "add documents" do
    visit add_change_in_hours_documents_screens_path
    page.attach_file("form[letters][]", Rails.root.join("spec", "fixtures", "image.jpg"), make_visible: true)
    expect(page).to have_text "image.jpg"

    click_on "Continue"

    expect(page).to_not have_text "Add your letter."

    visit add_change_in_hours_documents_screens_path
    expect(page).to have_text "image.jpg"

    click_on "Continue"

    expect(page).to_not have_text "Add your letter."
  end

  scenario "delete letters" do
    visit add_change_in_hours_documents_screens_path

    page.attach_file("form[letters][]", Rails.root.join("spec", "fixtures", "image.jpg"), make_visible: true)
    expect(page).to have_text "image.jpg"

    click_on "Delete"
    expect(page).to_not have_text "image.jpg"
    click_on "Continue"

    visit add_change_in_hours_documents_screens_path
    expect(page).to_not have_text "image.jpg"

    page.attach_file("form[letters][]", Rails.root.join("spec", "fixtures", "image.jpg"), make_visible: true)
    expect(page).to have_text "image.jpg"

    click_on "Continue"
    visit add_change_in_hours_documents_screens_path
    expect(page).to have_text "image.jpg"
    click_on "Delete"

    expect(page).to_not have_text "image.jpg"
  end
end
