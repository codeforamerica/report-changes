require "rails_helper"

RSpec.describe TextMessageConsentController do
  it_behaves_like "form controller base behavior"
  it_behaves_like "form controller successful update", { consent_to_sms: "yes" }
  it_behaves_like "form controller always shows"

  describe "edit" do
    it "assigns existing attributes" do
      current_change_report = create(:change_report, consent_to_sms: "yes")
      session[:current_change_report_id] = current_change_report.id

      get :edit

      form = assigns(:form)

      expect(form.consent_to_sms).to eq("yes")
    end
  end
end
