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

  context "with verifications" do
    scenario "viewing the pdf" do
      change_report = build(:change_report, navigator: build(:change_report_navigator, has_letter: "yes"))
      create(:household_member,
             name: "Todd Chavez",
             change_report: change_report)
      change_report.letters.attach(
        io: File.open(Rails.root.join("spec", "fixtures", "document.pdf")),
        filename: "document.pdf",
        content_type: "application/pdf",
      )
      change_report.letters.attach(
        io: File.open(Rails.root.join("spec", "fixtures", "image.jpg")),
        filename: "image.jpg",
        content_type: "image/jpg",
      )

      visit admin_root_path

      click_on "Download"

      pdf = PDF::Reader.new(StringIO.new(page.html))
      pdf_text = pdf.pages.first.text.gsub("\t", " ").gsub("\n", " ").squeeze(" ")
      pdf_attachment_text = pdf.pages.last.text

      expect(pdf_text).to have_content "Change Request Form"
      expect(pdf_text).to have_content "Todd Chavez"
      expect(pdf_text).to have_content "See attached"
      expect(pdf_text).to_not have_content "Supervisor or manager's name"

      expect(pdf_attachment_text).to have_content "This is the test pdf contents."
    end
  end

  context "without verifications" do
    scenario "viewing the pdf" do
      create(:household_member,
             name: "Todd Chavez",
             change_report: build(:change_report,
                                  manager_name: "Jane Doe",
                                  navigator: build(:change_report_navigator, has_letter: "no")))

      visit admin_root_path

      click_on "Download"

      pdf = PDF::Reader.new(StringIO.new(page.html))
      pdf_text = pdf.pages.first.text.gsub("\t", " ").gsub("\n", " ").squeeze(" ")

      expect(pdf_text).to have_content "Client does not have this"
      expect(pdf_text).to have_content "Supervisor or manager's name"
      expect(pdf_text).to have_content "Jane Doe"
    end
  end

  scenario "searching isn't broken", js: true do
    visit admin_root_path(search: "asdf")

    expect(page).to have_content("Change Report")
  end

  scenario "can download a csv of all the change reports" do
    change_report = create(:change_report, :with_member, signature: "YOOOOOOOO", signature_confirmation: "yes")

    visit admin_root_path

    click_on "Download All"

    expect(page).to have_text "YOOOOOOOO"
  end
end
