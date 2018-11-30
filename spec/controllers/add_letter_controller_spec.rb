require "rails_helper"

RSpec.describe AddLetterController do
  it_behaves_like "form controller base behavior"

  describe "#update" do
    context "without change report" do
      it "redirects to homepage" do
        put :update, params: { form: {} }

        expect(response).to redirect_to(root_path)
      end
    end

    context "with change report" do
      let(:current_report) { create(:report, :with_navigator) }
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

      context "with letters" do
        let(:valid_params) do
          {
            letters: ["", active_storage_blob.signed_id],
          }
        end

        it "redirects to next path" do
          put :update, params: { form: valid_params }

          expect(response).to redirect_to(subject.next_path)

          put :update, params: { form: valid_params }
        end
      end

      context "without letters (ie: Safari)" do
        let(:valid_params) do
          {}
        end

        it "redirects to next path" do
          put :update, params: { form: valid_params }

          expect(response).to redirect_to(subject.next_path)

          put :update, params: { form: valid_params }
        end
      end
    end
  end

  describe "show?" do
    context "when client has their letter" do
      it "returns true" do
        report = create(:report, navigator:
          build(:navigator, has_documents: "yes"))

        show_form = AddLetterController.show?(report)
        expect(show_form).to eq(true)
      end
    end

    context "when client does not have letter" do
      it "returns false" do
        report = create(:report, navigator:
          build(:navigator, has_documents: "no"))

        show_form = AddLetterController.show?(report)
        expect(show_form).to eq(false)
      end
    end
  end
end
