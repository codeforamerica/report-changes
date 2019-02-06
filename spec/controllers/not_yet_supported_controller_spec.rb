require "rails_helper"

RSpec.describe NotYetSupportedController do
  it_behaves_like "form controller base behavior"

  let(:report) { create :report, :filled }

  describe "show?" do
    context "when the client selects Arapahoe as their county" do
      it "returns false" do
        report.navigator.update(selected_county_location: :arapahoe)

        show_form = NotYetSupportedController.show?(report)
        expect(show_form).to eq(false)
      end
    end

    context "when the client's address is in Arapahoe County" do
      it "returns false" do
        report.navigator.update(county_from_address: "Arapahoe County")

        show_form = NotYetSupportedController.show?(report)
        expect(show_form).to eq(false)
      end
    end

    context "when the client's county is not Arapahoe" do
      it "returns true" do
        report.navigator.update(
          selected_county_location: :not_sure,
          county_from_address: "Jefferson County",
        )

        show_form = NotYetSupportedController.show?(report)
        expect(show_form).to eq(true)
      end
    end

    context "when a client is self-employed" do
      it "returns true" do
        report.current_change.change_navigator.update(is_self_employed: "yes")

        show_form = NotYetSupportedController.show?(report)

        expect(show_form).to be_truthy
      end
    end

    context "when a client is not self-employed" do
      it "returns false" do
        report.navigator.update(county_from_address: "Arapahoe County")
        report.current_change.change_navigator.update(is_self_employed: "no")

        show_form = NotYetSupportedController.show?(report)

        expect(show_form).to be_falsey
      end
    end
  end
end
