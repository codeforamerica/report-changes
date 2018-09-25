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
    context "when client has their letter" do
      it "returns true" do
        navigator = build(:change_report_navigator, has_letter: "yes")
        change_report = create(:change_report, navigator: navigator)

        show_form = AddLetterController.show?(change_report)
        expect(show_form).to eq(true)
      end
    end

    context "when client does not have letter" do
      it "returns false" do
        navigator = build(:change_report_navigator, has_letter: "no")
        change_report = create(:change_report, navigator: navigator)

        show_form = AddLetterController.show?(change_report)
        expect(show_form).to eq(false)
      end
    end
  end

  describe "edit" do
    it "assigns existing attributes" do
      current_change_report = create(:change_report, :with_navigator)
      session[:current_change_report_id] = current_change_report.id
      current_change_report.letters.attach(
        io: File.open(Rails.root.join("spec", "fixtures", "image.jpg")),
        filename: "image.jpg",
        content_type: "image/jpg",
      )

      get :edit

      form = assigns(:form)

      expect(form.letters.count).to eq 1
      expect(form.letters.first.filename).to eq "image.jpg"
    end
  end
end
