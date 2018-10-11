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

  describe "#update" do
    context "on success" do
      it "enqueues a pdf mailer job" do
        current_change_report = create(:change_report, :with_navigator)
        session[:current_change_report_id] = current_change_report.id

        allow(EmailChangeReportToOfficeJob).to receive(:perform_later)

        put :update, params: { form: valid_params }

        expect(EmailChangeReportToOfficeJob).to have_received(:perform_later).with(change_report: current_change_report)
      end
    end
  end
end
