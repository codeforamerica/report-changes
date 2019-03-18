require "rails_helper"

RSpec.describe CountyService do
  describe ".email_address" do
    it "should return the email of the report's county" do
      with_modified_env ARAPAHOE_EMAIL_ADDRESS: "arapahoe@email.com" do
        report = create(:report, county: "Arapahoe")
        expect(described_class.email_address(report)).to eq "arapahoe@email.com"
      end
    end

    it "should return nil when the county is nil" do
      report = create(:report, county: nil)
      expect(described_class.email_address(report)).to be_nil
    end
  end
end
