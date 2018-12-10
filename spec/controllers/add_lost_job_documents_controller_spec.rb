require "rails_helper"

RSpec.describe AddLostJobDocumentsController do
  it_behaves_like "form controller base behavior", "job_termination"
  it_behaves_like "add documents controller", "job_termination"

  describe "show?" do
    context "when client has job termination documents" do
      it "returns true" do
        report = create(:report,
                        navigator: build(:navigator, has_job_termination_documents: "yes"))

        show_form = AddLostJobDocumentsController.show?(report)
        expect(show_form).to eq(true)
      end
    end

    context "when client does not have job termination documents" do
      it "returns false" do
        report = create(:report,
                        navigator: build(:navigator, has_job_termination_documents: "no"))

        show_form = AddLostJobDocumentsController.show?(report)
        expect(show_form).to eq(false)
      end
    end
  end
end
