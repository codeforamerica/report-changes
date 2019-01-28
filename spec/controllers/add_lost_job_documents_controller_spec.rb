require "rails_helper"

RSpec.describe AddLostJobDocumentsController do
  it_behaves_like "form controller base behavior", "job_termination"
  it_behaves_like "add documents controller", "job_termination"

  describe "show?" do
    context "when client has job termination documents" do
      context "has not uploaded any documents yet" do
        it "returns true" do
          report = create(:report,
            navigator: build(:navigator, has_job_termination_documents: "yes"))
          create :change, report: report, change_type: "job_termination", documents: []

          show_form = AddLostJobDocumentsController.show?(report)
          expect(show_form).to eq(true)
        end
      end

      context "has already uploaded documents" do
        it "returns false" do
          report = create(:report,
            navigator: build(:navigator, has_job_termination_documents: "yes"))
          documents = [fixture_file_upload(Rails.root.join("spec", "fixtures", "image.jpg"), "image/jpg")]
          create :change, report: report, change_type: "job_termination", documents: documents

          show_form = AddLostJobDocumentsController.show?(report)
          expect(show_form).to eq(false)
        end
      end
    end

    context "when client does not have job termination documents" do
      it "returns false" do
        report = create(:report,
                        navigator: build(:navigator, has_job_termination_documents: "no"))
        create :change, report: report, change_type: "job_termination"

        show_form = AddLostJobDocumentsController.show?(report)
        expect(show_form).to eq(false)
      end
    end
  end
end
