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
      create(:household_member,
             name: "Todd Chavez",
             change_report: build(:change_report, navigator: build(:change_report_navigator, has_letter: "yes")))

      visit admin_root_path

      click_on "Download"

      pdf = PDF::Reader.new(StringIO.new(page.html))
      pdf_text = pdf.pages.map do |page|
        page.text.gsub("\t", " ").gsub("\n", " ").squeeze(" ")
      end.join(" ")

      expect(pdf_text).to have_content "Change Request Form"
      expect(pdf_text).to have_content "Todd Chavez"
      expect(pdf_text).to have_content "See attached"
      expect(pdf_text).to_not have_content "Supervisor or manager's name"
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
      pdf_text = pdf.pages.map do |page|
        page.text.gsub("\t", " ").gsub("\n", " ").squeeze(" ")
      end.join(" ")

      expect(pdf_text).to have_content "Client does not have this"
      expect(pdf_text).to have_content "Supervisor or manager's name"
      expect(pdf_text).to have_content "Jane Doe"
    end
  end

  scenario "searching isn't broken", js: true do
    visit admin_root_path(search: "asdf")

    expect(page).to have_content("Change Report")
  end
end
