require "rails_helper"

RSpec.describe ChangeTypeController do
  it_behaves_like "form controller base behavior"
  it_behaves_like "form controller successful update", {
    temp_change_type: "job_termination",
  }
  it_behaves_like "form controller unsuccessful update"
  it_behaves_like "form controller always shows"

  context "with existing current member and change" do
    it "clears them out" do
      report = create :report, :filled
      session[:current_report_id] = report.id

      expect(report.navigator.current_member).not_to be_nil

      put :update, params: { form: { temp_change_type: "job_termination" } }

      report.reload

      expect(report.navigator.current_member).to be_nil
    end
  end
end
