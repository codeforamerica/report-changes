require "rails_helper"

RSpec.describe AnyOtherChangesController do
  it_behaves_like "form controller base behavior"

  describe "#show" do
    context "possible other change types to report" do
      it "shows" do
        report = create :report, reported_changes: []

        expect(AnyOtherChangesController.show?(report)).to be_truthy
      end
    end

    context "all changes have been reported" do
      it "shows" do
        report = create :report
        create :change, change_type: :job_termination, report: report
        create :change, change_type: :new_job, report: report
        create :change, change_type: :change_in_hours, report: report

        expect(AnyOtherChangesController.show?(report)).to be_falsey
      end
    end
  end

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
