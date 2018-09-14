require "rails_helper"

RSpec.describe SkipRules do
  describe "#must_not_know_county_location" do
    context "with known county location" do
      it "returns true" do
        change_report_navigator = instance_double(ChangeReportNavigator, selected_county_location_not_sure?: false)
        change_report = instance_double(ChangeReport, navigator: change_report_navigator)

        expect(SkipRules.must_not_know_county_location(change_report)).to eq(true)
      end
    end

    context "with not sure county location" do
      it "returns false" do
        change_report_navigator = instance_double(ChangeReportNavigator, selected_county_location_not_sure?: true)
        change_report = instance_double(ChangeReport, navigator: change_report_navigator)

        expect(SkipRules.must_not_know_county_location(change_report)).to be_falsey
      end
    end
  end

  describe "#must_have_supported_county" do
    context "with supported county" do
      it "returns false" do
        change_report_navigator = instance_double(ChangeReportNavigator, supported_county?: true)
        change_report = instance_double(ChangeReport, navigator: change_report_navigator)

        expect(SkipRules.must_have_supported_county(change_report)).to be_falsey
      end
    end

    context "with not supported county" do
      it "returns true" do
        change_report_navigator = instance_double(ChangeReportNavigator, supported_county?: false)
        change_report = instance_double(ChangeReport, navigator: change_report_navigator)

        expect(SkipRules.must_have_supported_county(change_report)).to eq(true)
      end
    end
  end
end
