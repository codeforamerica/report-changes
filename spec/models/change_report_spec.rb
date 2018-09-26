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
end
