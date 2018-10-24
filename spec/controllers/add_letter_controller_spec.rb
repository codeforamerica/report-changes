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
      let(:current_change_report) { create(:change_report, :with_navigator) }
      let(:active_storage_blob) do
        ActiveStorage::Blob.create_after_upload!(
          io: File.open(Rails.root.join("spec", "fixtures", "image.jpg")),
          filename: "image.jpg",
          content_type: "image/jpg",
        )
      end
      let(:valid_params) do
        {
          letters: ["", active_storage_blob.signed_id],
        }
      end

      before do
        session[:current_change_report_id] = current_change_report.id
      end

      context "on successful update" do
        it "redirects to next path" do
          put :update, params: { form: valid_params }

          expect(response).to redirect_to(subject.next_path)

          put :update, params: { form: valid_params }
        end
      end
    end
  end

  describe "show?" do
    context "lost a job" do
      context "when client has their letter" do
        it "returns true" do
          change_report = create(:change_report, navigator:
            build(:change_report_navigator, has_termination_letter: "yes"))

          show_form = AddLetterController.show?(change_report)
          expect(show_form).to eq(true)
        end
      end

      context "when client does not have letter" do
        it "returns false" do
          change_report = create(:change_report, navigator:
            build(:change_report_navigator, has_termination_letter: "no"))

          show_form = AddLetterController.show?(change_report)
          expect(show_form).to eq(false)
        end
      end
    end

    context "new job" do
      context "when client has an offer letter" do
        it "returns true" do
          change_report = create(:change_report, navigator:
            build(:change_report_navigator, has_offer_letter: "yes"))

          show_form = AddLetterController.show?(change_report)
          expect(show_form).to eq(true)
        end
      end

      context "when client has an offer letter and a paystub" do
        it "returns true" do
          change_report = create(:change_report, navigator:
            build(:change_report_navigator, has_offer_letter: "yes", has_paystub: "yes"))

          show_form = AddLetterController.show?(change_report)
          expect(show_form).to eq(true)
        end
      end

      context "when client has a paystub" do
        it "returns true" do
          change_report = create(:change_report, navigator:
            build(:change_report_navigator, has_paystub: "yes"))

          show_form = AddLetterController.show?(change_report)
          expect(show_form).to eq(true)
        end
      end

      context "when client has no proof" do
        it "returns false" do
          change_report = create(:change_report, navigator:
            build(:change_report_navigator, has_offer_letter: "no", has_paystub: "no"))

          show_form = AddLetterController.show?(change_report)
          expect(show_form).to eq(false)
        end
      end
    end
  end
end
