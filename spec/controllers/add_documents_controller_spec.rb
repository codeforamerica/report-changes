require "rails_helper"

RSpec.describe AddDocumentsController do
  describe "show?" do
    context "when client has documents to upload" do
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


  describe "#update" do
    context "without change report" do
      it "redirects to homepage" do
        put :update, params: { form: {} }

        expect(response).to redirect_to(root_path)
      end
    end

    context "with change report" do
      let(:current_report) do
        create(:report, :with_navigator, :with_change, change_type: "job_termination")
      end

      let(:active_storage_blob) do
        ActiveStorage::Blob.create_after_upload!(
          io: File.open(Rails.root.join("spec", "fixtures", "image.jpg")),
          filename: "image.jpg",
          content_type: "image/jpg",
        )
      end

      before do
        session[:current_report_id] = current_report.id
      end

      context "with documents" do
        let(:valid_params) do
          {
            documents: ["", active_storage_blob.signed_id],
          }
        end

        it "redirects to next path" do
          put :update, params: { form: valid_params }

          expect(response).to redirect_to(subject.next_path)
        end
      end

      context "without documents (ie: Safari)" do
        let(:valid_params) do
          {}
        end

        it "redirects to next path" do
          put :update, params: { form: valid_params }

          expect(response).to redirect_to(subject.next_path)
        end
      end
    end
  end
end
