require "rails_helper"
require "#{Rails.root}/lib/summarizer/application_summary"

RSpec.describe Summarizer::ApplicationSummary do
  describe "#run" do
    it "returns a summary of daily change reports for date and timezone" do
      date = DateTime.new(2017, 12, 1, 0, 0)

      create_list(:report, 2, signature: "Signature", created_at: date)

      create(:report, signature: "Signature", created_at: date - 1.day)
      create(:report, signature: "Signature", created_at: date + 21.hours)
      create(:report, signature: "Signature", created_at: date + 1.day)

      text = Summarizer::ApplicationSummary.new(
        date,
        "Europe/Samara", # +4 UTC Offset
      ).daily_summary

      expect(text).to include(
        "On Fri, Dec 01, we processed 2 change reports.",
      )
    end

    it "only includes signed change reports" do
      date = DateTime.new(2017, 12, 1, 12, 0)

      create(:report, created_at: date)
      create(:report, signature: "Signature", created_at: date)

      text = Summarizer::ApplicationSummary.new(
        date,
        "America/New_York",
      ).daily_summary

      expect(text).to include(
        "On Fri, Dec 01, we processed 1 change report.",
      )
    end
  end
end
