require "rails_helper"

RSpec.describe ChangeReport, type: :model do
  describe ".signed" do
    it "only returns signed change reports" do
      signed_change_report = create :change_report, signature_confirmation: "yes", signature: "Quincy Jones"
      second_signed_change_report = create :change_report, signature_confirmation: "yes", signature: "Frank Sinatra"
      _unsigned_change_report = create :change_report, signature_confirmation: "unfilled", signature: "Count Basie"

      expect(ChangeReport.signed).to eq [signed_change_report, second_signed_change_report]
    end
  end

  describe "#has_feedback?" do
    let(:change_report) do
      create :change_report, feedback_rating: "unfilled", feedback_comments: "This was so helpful."
    end

    it "returns true if there is either a rating that has been filled or comments left" do
      expect(change_report.has_feedback?).to be_truthy
    end

    it "returns false if there is no feedback left" do
      change_report.feedback_comments = nil

      expect(change_report.has_feedback?).to be_falsey
    end
  end

  describe "#mixpanel_data" do
    let(:change_report) do
      create :change_report, :with_navigator, :with_letter,
        member: create(:household_member, birthday: (30.years.ago - 1.day))
    end

    it "returns a non-PII representation of change report data" do
      expect(change_report.mixpanel_data).to eq(
        {
          selected_county_location: "unfilled",
          county_from_address: nil,
          age: 30,
          has_letter: "unfilled",
          letter_count: 1,
          consent_to_sms: "unfilled",
          signature_confirmation: "unfilled",
          feedback_rating: "unfilled",
        },
      )
    end
  end

  describe "#pdf_letters" do
    it "returns all letters that are content_type application/pdf" do
      change_report = create :change_report
      change_report.letters.attach(
        io: File.open(Rails.root.join("spec", "fixtures", "image.jpg")),
        filename: "image.jpg",
        content_type: "image/jpg",
      )
      change_report.letters.attach(
        io: File.open(Rails.root.join("spec", "fixtures", "document.pdf")),
        filename: "document.pdf",
        content_type: "application/pdf",
      )

      expect(change_report.pdf_letters.count).to eq 1
      expect(change_report.pdf_letters.first.filename).to eq "document.pdf"
    end
  end

  describe "#image_letters" do
    it "returns all letters that are of image type" do
      change_report = create :change_report
      change_report.letters.attach(
        io: File.open(Rails.root.join("spec", "fixtures", "image.jpg")),
        filename: "image.jpg",
        content_type: "image/jpg",
      )
      change_report.letters.attach(
        io: File.open(Rails.root.join("spec", "fixtures", "document.pdf")),
        filename: "document.pdf",
        content_type: "application/pdf",
      )

      expect(change_report.image_letters.count).to eq 1
      expect(change_report.image_letters.first.filename).to eq "image.jpg"
    end
  end
end
