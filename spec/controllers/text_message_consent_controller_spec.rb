require "rails_helper"

RSpec.describe TextMessageConsentController do
  it_behaves_like "form controller base behavior"
  it_behaves_like "form controller successful update", { consent_to_sms: "yes" }

  let(:report) { create :report, :filled }

  describe "show?" do
    context "when client has not reported a change for themselves" do
      it "returns false" do
        report.current_member.update is_submitter: false

        show_form = TextMessageConsentController.show?(report)
        expect(show_form).to eq(false)
      end
    end

    context "when client is submitting for themselves" do
      before { report.current_member.update is_submitter: true }

      context "when phone number has not been provided" do
        it "returns false" do
          report.current_member.update phone_number: nil

          show_form = TextMessageConsentController.show?(report)
          expect(show_form).to eq(false)
        end
      end

      context "when phone number has been provided" do
        it "returns true" do
          report.current_member.update phone_number: "5551112222"

          show_form = TextMessageConsentController.show?(report)
          expect(show_form).to eq(true)
        end
      end
    end
  end

  describe "edit" do
    it "assigns existing attributes" do
      report.metadata.update consent_to_sms: "yes"
      session[:current_report_id] = report.id

      get :edit

      form = assigns(:form)

      expect(form.consent_to_sms).to eq("yes")
    end
  end
end
