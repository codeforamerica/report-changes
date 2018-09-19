require "rails_helper"

RSpec.describe RightsAndResponsibilitiesController do
  it_behaves_like "form controller"

  describe "#show?" do
    it "returns true" do
      change_report = create(:change_report)

      show_form = RightsAndResponsibilitiesController.show?(change_report)
      expect(show_form).to eq(true)
    end
  end
end
