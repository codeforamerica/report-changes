require "rails_helper"

RSpec.describe SignSubmitController do
  it_behaves_like "form controller"

  describe "#show?" do
    it "always returns true" do
      show_form = SignSubmitController.show?(nil)
      expect(show_form).to eq(true)
    end
  end

  describe "edit" do
    it "assigns existing attributes" do
      current_change_report = create(:change_report, signature: "Best E. Person")
      session[:current_change_report_id] = current_change_report.id

      get :edit

      form = assigns(:form)

      expect(form.signature).to eq("Best E. Person")
    end
  end

  describe "#update" do
    context "with valid params" do
      let(:valid_params) do
        {
          signature: "Best E. Person",
        }
      end

      context "without change report" do
        it "redirects to homepage" do
          put :update, params: { form: valid_params }

          expect(response).to redirect_to(root_path)
        end
      end

      context "with an existing change report and navigator" do
        it "redirects to next path updates the models" do
          current_change_report = create(:change_report, :with_navigator)
          session[:current_change_report_id] = current_change_report.id

          put :update, params: { form: valid_params }

          current_change_report.reload

          expect(response).to redirect_to(subject.next_path)
          expect(current_change_report.signature).to eq("Best E. Person")
        end
      end
    end

    context "with invalid params" do
      let(:invalid_params) do
        {
          signature: "",
        }
      end

      it "renders edit without updating" do
        current_change_report = create(:change_report, :with_navigator, signature: "Second B. Person")
        session[:current_change_report_id] = current_change_report.id

        put :update, params: { form: invalid_params }

        expect(response).to render_template(:edit)
        expect(current_change_report.signature).to eq("Second B. Person")
      end
    end
  end
end
