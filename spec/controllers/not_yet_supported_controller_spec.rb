require "rails_helper"

RSpec.describe NotYetSupportedController do
  it_behaves_like "form controller base behavior"

  let(:report) { create :report, :filled }

  describe "show?" do
    context "one of our counties" do
      it "returns false" do
        report.navigator.update(county: "Arapahoe")

        show_form = NotYetSupportedController.show?(report)
        expect(show_form).to eq(false)
      end
    end

    context "not in one of our counties" do
      it "returns true" do
        report.navigator.update(zip_code: "blah")

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
        report.navigator.update(county: "Arapahoe")
        report.current_change.change_navigator.update(is_self_employed: "no")

        show_form = NotYetSupportedController.show?(report)

        expect(show_form).to be_falsey
      end
    end
  end
end
