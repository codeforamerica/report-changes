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
    context "when client has their letter and lost a job" do
      it "returns true" do
        navigator = build(:change_report_navigator, has_termination_letter: "yes")
        change_report = create(:change_report, navigator: navigator, change_type: :job_termination)

        show_form = AddLetterController.show?(change_report)
        expect(show_form).to eq(true)
      end
    end

    context "when client does not have letter and lost a job" do
      it "returns false" do
        navigator = build(:change_report_navigator, has_termination_letter: "no")
        change_report = create(:change_report, navigator: navigator, change_type: :job_termination)

        show_form = AddLetterController.show?(change_report)
        expect(show_form).to eq(false)
      end
    end

    context "when client has a letter but did not lose a job" do
      it "returns false" do
        navigator = build(:change_report_navigator, has_termination_letter: "yes")
        change_report = create(:change_report, navigator: navigator, change_type: :new_job)

        show_form = AddLetterController.show?(change_report)
        expect(show_form).to eq(false)
      end
    end
  end
end
