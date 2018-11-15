require "rails_helper"

RSpec.describe ChangeReportMetadata, type: :model do
  describe "#has_feedback?" do
    let(:metadata) do
      create :change_report_metadata,
             feedback_rating: "unfilled",
             feedback_comments: "This was so helpful.",
             change_report: build(:change_report)
    end

    it "returns true if there is either a rating that has been filled or comments left" do
      expect(metadata.has_feedback?).to be_truthy
    end

    it "returns false if there is no feedback left" do
      metadata.feedback_comments = nil

      expect(metadata.has_feedback?).to be_falsey
    end
  end
end
