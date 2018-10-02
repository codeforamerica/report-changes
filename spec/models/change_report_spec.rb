require "rails_helper"

RSpec.describe ChangeReport, type: :model do
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
end
