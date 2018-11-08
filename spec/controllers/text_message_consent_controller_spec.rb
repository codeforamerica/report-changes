require "rails_helper"

RSpec.describe TextMessageConsentController do
  it_behaves_like "form controller base behavior"
  it_behaves_like "form controller successful update", { consent_to_sms: "yes" }

  describe "show?" do
    context "when client is submitting on behalf of someone" do
      it "returns false" do
        change_report = create(:change_report, submitting_for: "other_household_member")

        show_form = TextMessageConsentController.show?(change_report)
        expect(show_form).to eq(false)
      end
    end

    context "when client is submitting for themselves" do
      it "returns true" do
        change_report = create(:change_report, submitting_for: "self")

        show_form = TextMessageConsentController.show?(change_report)
        expect(show_form).to eq(true)
      end
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
