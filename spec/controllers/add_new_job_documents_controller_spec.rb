require "rails_helper"

RSpec.describe AddNewJobDocumentsController do
  it_behaves_like "form controller base behavior", "new_job"
  it_behaves_like "add documents controller", "new_job"

  describe "show?" do
    context "when client has new job documents" do
      it "returns true" do
        report = create(:report,
                        navigator: build(:navigator, has_new_job_documents: "yes"))

        show_form = AddNewJobDocumentsController.show?(report)
        expect(show_form).to eq(true)
      end
    end

    context "when client does not have new job documents" do
      it "returns false" do
        report = create(:report,
                        navigator: build(:navigator, has_new_job_documents: "no"))

        show_form = AddNewJobDocumentsController.show?(report)
        expect(show_form).to eq(false)
      end
    end
  end
end
