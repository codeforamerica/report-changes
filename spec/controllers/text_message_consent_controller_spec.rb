require "rails_helper"

RSpec.describe TextMessageConsentController do
  it_behaves_like "form controller"

  describe "#show?" do
    it "always returns true" do
      change_report = create(:change_report)

      show_form = TextMessageConsentController.show?(change_report)
      expect(show_form).to eq(true)
    end
  end

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
