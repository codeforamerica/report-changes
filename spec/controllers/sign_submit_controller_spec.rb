require "rails_helper"

RSpec.describe SignSubmitController do
  valid_params = { signature: "Best E. Person" }

  it_behaves_like "form controller base behavior"
  it_behaves_like "form controller successful update", valid_params
  it_behaves_like "form controller unsuccessful update"
  it_behaves_like "form controller always shows"

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
