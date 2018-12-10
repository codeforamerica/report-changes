require "rails_helper"

RSpec.describe Report, type: :model do
  describe ".signed" do
    it "only returns signed change reports" do
      signed_report = create :report, signature: "Quincy Jones"
      second_signed_report = create :report, signature: "Frank Sinatra"
      _unsigned_report = create :report

      expect(Report.signed).to eq [signed_report, second_signed_report]
    end
  end
end
