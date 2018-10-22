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
      change_report = build(:change_report, navigator: build(:change_report_navigator, has_termination_letter: "yes"))
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

      expect(pdf_attachment_text).to have_content "This is the test pdf contents."
    end
  end

  scenario "searching isn't broken", js: true do
    visit admin_root_path(search: "asdf")

    expect(page).to have_content("Change Report")
  end

  scenario "can download a csv of all the change reports" do
    create(:change_report, :with_member, signature: "st", manager_name: "Lavar Burton")
    create(:change_report, :with_member, signature: "julie", manager_name: "Bob Ross")
    create(:change_report, :with_member, signature: nil, manager_name: "Mr Burns")

    visit admin_root_path

    click_on "Download All"

    expect(page).to have_text "Lavar Burton"
    expect(page).to have_text "Bob Ross"
    expect(page).not_to have_text "Mr Burns"
  end
end
