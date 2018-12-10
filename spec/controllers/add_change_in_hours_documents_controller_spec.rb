require "rails_helper"

RSpec.describe AddChangeInHoursDocumentsController do
  it_behaves_like "form controller base behavior", "change_in_hours"
  it_behaves_like "add documents controller", "change_in_hours"

  describe "show?" do
    context "when client has change in hours documents" do
      it "returns true" do
        report = create(:report,
                        navigator: build(:navigator, has_change_in_hours_documents: "yes"))

        show_form = AddChangeInHoursDocumentsController.show?(report)
        expect(show_form).to eq(true)
      end
    end

    context "when client does not have change in hours documents" do
      it "returns false" do
        report = create(:report,
                        navigator: build(:navigator, has_change_in_hours_documents: "no"))

        show_form = AddChangeInHoursDocumentsController.show?(report)
        expect(show_form).to eq(false)
      end
    end
  end
end
