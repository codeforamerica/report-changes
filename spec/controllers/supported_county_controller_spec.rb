require "rails_helper"

RSpec.describe SupportedCountyController do
  it_behaves_like "form controller base behavior"

  describe "show?" do
    context "when the client selects Arapahoe as their county" do
      it "returns false" do
        navigator = build(:change_report_navigator, selected_county_location: :arapahoe)
        change_report = create(:change_report, navigator: navigator)

        show_form = SupportedCountyController.show?(change_report)
        expect(show_form).to eq(false)
      end
    end

    context "when the client's address is in Arapahoe County" do
      it "returns true" do
        navigator = build(:change_report_navigator, county_from_address: "Arapahoe County")
        change_report = create(:change_report, navigator: navigator)

        show_form = SupportedCountyController.show?(change_report)
        expect(show_form).to eq(true)
      end
    end

    context "when the client's county is not Arapahoe" do
      it "returns false" do
        navigator = build(:change_report_navigator,
                          selected_county_location: :not_sure,
                          county_from_address: "Jefferson County")
        change_report = create(:change_report, navigator: navigator)

        show_form = SupportedCountyController.show?(change_report)
        expect(show_form).to eq(false)
      end
    end
  end
end
