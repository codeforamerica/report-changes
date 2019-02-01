require "rails_helper"

RSpec.describe AnyOtherChangesController do
  it_behaves_like "form controller base behavior"
  it_behaves_like "form controller always shows"

  describe "#update" do
    before do
      report = create :report, :with_metadata, :with_navigator
      create :change, change_type: :job_termination, report: report
      session[:current_report_id] = report.id
    end
    context "yes they have more changes to report" do
      it "redirect to change type screen" do
        put :update, params: { form: { any_other_changes: "yes" } }

        expect(response).to redirect_to(change_type_screens_path)
      end
    end

    context "no more changes" do
      it "keep going to next page" do
        put :update, params: { form: { any_other_changes: "no" } }

        expect(response).to redirect_to(want_a_copy_screens_path)
      end
    end
  end
end
