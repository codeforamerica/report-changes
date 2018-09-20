require "rails_helper"

RSpec.describe SignSubmitController do
  it_behaves_like "form controller base behavior"
  it_behaves_like "form controller successful update", { signature: "Best E. Person" }
  it_behaves_like "form controller unsuccessful update"

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
end
