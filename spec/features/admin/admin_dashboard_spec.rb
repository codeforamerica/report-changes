require "rails_helper"

RSpec.feature "Admin viewing dashboard" do
  scenario "admin can view login page" do
    visit admin_root_path

    expect(page).to have_content "Log in"
  end

  context "logged in admin" do
    let(:report) { create :report, :filled, change_type: "job_termination" }

    before do
      user = create(:admin_user)
      login_as(user)

      report.metadata.update consent_to_sms: "no"
      report.current_member.update first_name: "Todd", last_name: "Chavez"

      report.current_change.documents.attach(
        io: File.open(Rails.root.join("spec", "fixtures", "document.pdf")),
        filename: "document.pdf",
        content_type: "application/pdf",
      )
      report.current_change.documents.attach(
        io: File.open(Rails.root.join("spec", "fixtures", "image.jpg")),
        filename: "image.jpg",
        content_type: "image/jpg",
      )
    end

    scenario "viewing details for a report" do
      visit admin_root_path

      expect(page).to have_content("Report")

      click_on report.id

      expect(page).to have_content("Report ##{report.id}")
      expect(page).to have_content("CONSENT TO SMS", "no")

      click_on report.reported_changes.last.id

      expect(page).to have_content("Change ##{report.reported_changes.last.id}")
    end

    context "with verifications" do
      scenario "viewing the pdf" do
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

      expect(page).to have_content("Report")
    end

    context "when a submitter is included in the report" do
      scenario "admin page uses the submitter phone and case number" do
        report.members.first.update(
          is_submitter: "yes",
          phone_number: "5555555555",
          case_number: "SUBMITTER CASE NUMBER",
        )
        create(:member,
          report: report,
          is_submitter: "no",
          phone_number: "1111111111",
          case_number: "OTHER PERSON")

        visit admin_root_path

        expect(page).to have_content("SUBMITTER CASE NUMBER")

        click_on report.id

        expect(page).to have_content("SUBMITTER CASE NUMBER")
        expect(page).to have_content("5555555555")
      end
    end

    context "when no submitter is included in the report" do
      scenario "report uses first non-submitter phone and case number" do
        report.members.first.update(
          is_submitter: "no",
          phone_number: "5555555555",
          case_number: "FIRST OTHER PERSONCASE NUMBER",
        )
        create(:member,
          report: report,
          is_submitter: "no",
          phone_number: "1111111111",
          case_number: "OTHER PERSON")

        visit admin_root_path

        expect(page).to have_content("FIRST OTHER PERSONCASE NUMBER")

        click_on report.id

        expect(page).to have_content("FIRST OTHER PERSONCASE NUMBER")
        expect(page).to have_content("5555555555")
      end
    end

    scenario "can download a csv of all the change reports" do
      multiple_change_report = create(:report, :filled, signature: "multiple changes for multiple people")
      create(:change,
        change_type: :job_termination,
        manager_name: "Lavar Burton",
        member: multiple_change_report.members.first)
      another_member = create(:member,
        report: multiple_change_report,
        first_name: "another",
        last_name: "person")
      create(:change,
        change_type: :new_job,
        manager_name: "Bob Ross",
        member: another_member)

      no_signature_report = create(:report, :filled, signature: nil)
      create(:change,
        change_type: :job_termination,
        manager_name: "Mr Burns",
        member: no_signature_report.members.first)

      visit admin_root_path

      click_on "Download All"

      expect(page).to have_text "Lavar Burton"
      expect(page).to have_text "Bob Ross"

      expect(page).not_to have_text "Mr Burns"
    end
  end
end
