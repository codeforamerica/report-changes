require "rails_helper"

RSpec.shared_examples_for "add documents controller" do |change_type|
  describe "#update" do
    context "without change report" do
      it "redirects to homepage" do
        put :update, params: { form: {} }

        expect(response).to redirect_to(root_path)
      end
    end

    context "with change report" do
      let(:current_report) do
        create(:report, :with_navigator, :with_change, change_type: change_type)
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
