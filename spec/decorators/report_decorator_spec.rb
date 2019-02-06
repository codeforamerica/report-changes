require "rails_helper"

RSpec.describe ReportDecorator do
  describe "#submitted_at" do
    context "when there is a submitted_at" do
      it "formats it and converts it to Mountain time" do
        submitted_at = DateTime.new(2018, 2, 3, 19, 5, 6)
        report = create :report, submitted_at: submitted_at

        decorator = ReportDecorator.new(report)

        expect(decorator.submitted_at).to eq "02/03/18, 12:05 PM"
      end
    end

    context "when there is not a submitted_at" do
      it "returns nil" do
        report = create :report, submitted_at: nil

        decorator = ReportDecorator.new(report)

        expect(decorator.submitted_at).to be_nil
      end
    end
  end
end
