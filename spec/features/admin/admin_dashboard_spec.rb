require "rails_helper"

RSpec.feature "Admin viewing dashboard" do
  scenario "admin can view login page" do
    visit admin_root_path

    expect(page).to have_content "Log in"
  end

  context "logged in admin" do
    before do
      user = create(:admin_user)
      login_as(user)
    end

    scenario "logged out after 30 minutes inactive" do
      report = create(:report, :with_change, :with_metadata, change_type: "job_termination", consent_to_sms: "no")

      visit admin_root_path

      Timecop.travel(Time.now + 31.minutes)

      click_on report.id

      expect(page).to have_content "Log in"

      Timecop.return
    end

    scenario "viewing details for a report" do
      report = create(:report, :with_change, :with_metadata, change_type: "job_termination", consent_to_sms: "no")

      visit admin_root_path

      expect(page).to have_content("Report")

      click_on report.id

      expect(page).to have_content("Report ##{report.id}")
      expect(page).to have_content("CONSENT TO SMS", "no")

      click_on report.job_termination_change.id

      expect(page).to have_content("Change ##{report.job_termination_change.id}")
    end

    context "with verifications" do
      scenario "viewing the pdf" do
        report = build(:report,
          navigator: build(:navigator, has_job_termination_documents: "yes"))
        create(:member,
               first_name: "Todd",
               last_name: "Chavez",
               report: report)
        change = create(:change, change_type: "job_termination", report: report)

        change.documents.attach(
          io: File.open(Rails.root.join("spec", "fixtures", "document.pdf")),
          filename: "document.pdf",
          content_type: "application/pdf",
        )
        change.documents.attach(
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

      expect(page).to have_content("Report")
    end

    scenario "can download a csv of all the change reports" do
      create(:report,
        :with_member,
        signature: "st",
        job_termination_change: build(:change,
          change_type: :job_termination,
          manager_name: "Lavar Burton"))
      create(:report,
        :with_member,
        signature: "julie",
        new_job_change: build(:change,
          change_type: :new_job,
          manager_name: "Bob Ross"))
      create(:report,
        :with_member,
        signature: "mike",
        change_in_hours_change: build(:change,
          change_type: :change_in_hours,
          manager_name: "Michael Scott"))
      create(:report,
        :with_member,
        signature: nil,
        job_termination_change: build(:change,
          change_type: :job_termination,
          manager_name: "Mr Burns"))

      visit admin_root_path

      click_on "Download All"

      expect(page).to have_text "Lavar Burton"
      expect(page).to have_text "Bob Ross"
      expect(page).to have_text "Michael Scott"

      expect(page).not_to have_text "Mr Burns"
    end
  end
end
