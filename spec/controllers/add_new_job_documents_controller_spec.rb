require "rails_helper"

RSpec.describe AddNewJobDocumentsController do
  it_behaves_like "form controller base behavior", "new_job"
  it_behaves_like "add documents controller", "new_job"

  describe "show?" do
    context "when client has new job documents" do
      context "has not uploaded anything yet" do
        it "returns true" do
          report = create(:report,
            navigator: build(:navigator, has_new_job_documents: "yes"))
          create :change, report: report, change_type: "new_job", documents: []

          show_form = AddNewJobDocumentsController.show?(report)
          expect(show_form).to eq(true)
        end
      end

      context "already uploaded some documents" do
        it "returns false" do
          report = create(:report,
            navigator: build(:navigator, has_new_job_documents: "yes"))
          documents = [fixture_file_upload(Rails.root.join("spec", "fixtures", "image.jpg"), "image/jpg")]
          create :change, report: report, change_type: "new_job", documents: documents

          show_form = AddNewJobDocumentsController.show?(report)
          expect(show_form).to eq(false)
        end
      end
    end

    context "when client does not have new job documents" do
      it "returns false" do
        report = create(:report,
                        navigator: build(:navigator, has_new_job_documents: "no"))
        create :change, report: report, change_type: "new_job"

        show_form = AddNewJobDocumentsController.show?(report)
        expect(show_form).to eq(false)
      end
    end
  end
end
