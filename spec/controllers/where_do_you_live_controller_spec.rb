require "rails_helper"

RSpec.describe WhereDoYouLiveController do
  it_behaves_like "form controller base behavior"
  it_behaves_like "form controller successful update", {
    zip_code: "11111",
    city: "Littleton",
    street_address: "123 Main St",
  }
  it_behaves_like "form controller unsuccessful update"

  let(:change_report) { create :change_report }

  describe "show?" do
    context "when the client lives in Arapahoe County" do
      it "returns false" do
        change_report.navigator.update selected_county_location: :arapahoe

        show_form = WhereDoYouLiveController.show?(change_report)
        expect(show_form).to eq(false)
      end
    end

    context "when the client does not live in Arapahoe County" do
      it "returns false" do
        change_report.navigator.update selected_county_location: :not_arapahoe

        show_form = WhereDoYouLiveController.show?(change_report)
        expect(show_form).to eq(false)
      end
    end

    context "when the client doesn't know if they live in Arapahoe County" do
      it "returns true" do
        change_report.navigator.update selected_county_location: :not_sure

        show_form = WhereDoYouLiveController.show?(change_report)
        expect(show_form).to eq(true)
      end
    end
  end
end
