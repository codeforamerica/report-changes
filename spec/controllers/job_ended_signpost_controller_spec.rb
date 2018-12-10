require "rails_helper"

RSpec.describe JobEndedSignpostController do
  it_behaves_like "form controller base behavior", "job_termination"

  describe "#show?" do
    context "when a single change type is being reported" do
      it "returns false" do
        report = create(:report, :with_change, change_type: "job_termination")

        show_form = JobEndedSignpostController.show?(report)
        expect(show_form).to eq(false)
      end
    end

    context "when multiple change types are being reported" do
      context "and change types include job_termination" do
        it "returns true" do
          report = create(:report)
          create(:change, change_type: "job_termination", report: report)
          create(:change, change_type: "new_job", report: report)

          show_form = JobEndedSignpostController.show?(report)
          expect(show_form).to eq(true)
        end
      end

      context "and change types do not include job_termination" do
        it "returns false" do
          report = create(:report)
          create(:change, change_type: "change_in_hours", report: report)
          create(:change, change_type: "new_job", report: report)

          show_form = JobEndedSignpostController.show?(report)
          expect(show_form).to eq(false)
        end
      end
    end
  end
end
