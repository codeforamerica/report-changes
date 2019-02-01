require "rails_helper"

RSpec.describe AddDocumentsController do
  it_behaves_like "form controller base behavior", "change_in_hours"

  describe "show?" do
    context "when client has documents for this change" do
      it "returns true" do
        report = create :report,
          reported_changes: [
            create(:change, change_navigator:
              create(:change_navigator, has_documents: "yes")),
          ]

        show_form = AddDocumentsController.show?(report)
        expect(show_form).to eq(true)
      end
    end

    context "when client does not have change in hours documents" do
      it "returns false" do
        report = create :report,
          reported_changes: [
            create(:change, change_navigator:
              create(:change_navigator, has_documents: "no")),
          ]

        show_form = AddDocumentsController.show?(report)
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
        create :report, reported_changes: [create(:change)]
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
