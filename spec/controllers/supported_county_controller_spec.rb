require "rails_helper"

RSpec.describe SupportedCountyController do
  it_behaves_like "form controller base behavior"

  let(:change_report) { create :change_report }

  describe "show?" do
    context "when the client selects Arapahoe as their county" do
      it "returns false" do
        change_report.navigator.update selected_county_location: :arapahoe

        show_form = SupportedCountyController.show?(change_report)
        expect(show_form).to eq(false)
      end
    end

    context "when the client's address is in Arapahoe County" do
      it "returns true" do
        change_report.navigator.update county_from_address: "Arapahoe County"

        show_form = SupportedCountyController.show?(change_report)
        expect(show_form).to eq(true)
      end
    end

    context "when the client's county is not Arapahoe" do
      it "returns false" do
        change_report.navigator.update(
          selected_county_location: :not_sure,
          county_from_address: "Jefferson County")

        show_form = SupportedCountyController.show?(change_report)
        expect(show_form).to eq(false)
      end
    end
  end
end
