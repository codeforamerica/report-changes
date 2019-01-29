require "rails_helper"

RSpec.describe ShowRules do
  describe "#show_for_job_termination" do
    context "when report has job termination change type" do
      context "required has_job_termination_documents is unanswered" do
        it "returns true" do
          report = create :report
          create :change, change_type: "job_termination", report: report
          create :navigator, has_job_termination_documents: :unfilled, report: report

          expect(ShowRules.show_for_job_termination(report)).to eq(true)
        end
      end

      context "required has_job_termination_documents is already answered" do
        it "returns true" do
          report = create :report
          create :change, change_type: "job_termination", report: report
          create :navigator, has_job_termination_documents: :yes, report: report

          expect(ShowRules.show_for_job_termination(report)).to eq(false)
        end
      end
    end

    context "when report doesn't have job termination change type" do
      it "returns false" do
        report = create(:report, :with_change, change_type: "new_job")

        expect(ShowRules.show_for_job_termination(report)).to eq(false)
      end
    end
  end

  describe "#show_for_new_job" do
    context "when report has new job change type" do
      context "required has_new_job_documents is unanswered" do
        it "returns true" do
          report = create :report
          create :change, change_type: "new_job", report: report
          create :navigator, has_new_job_documents: :unfilled, report: report

          expect(ShowRules.show_for_new_job(report)).to eq(true)
        end
      end

      context "required has_new_job_documents is already answered" do
        it "returns true" do
          report = create :report
          create :change, change_type: "new_job", report: report
          create :navigator, has_new_job_documents: :no, report: report

          expect(ShowRules.show_for_new_job(report)).to eq(false)
        end
      end
    end

    context "when report doesn't have new job change type" do
      it "returns false" do
        report = create(:report, :with_change, change_type: "job_termination")

        expect(ShowRules.show_for_new_job(report)).to eq(false)
      end
    end
  end

  describe "#show_for_change_in_hours" do
    context "when report has change in hours change type" do
      context "required has_change_in_hours_documents is unanswered" do
        it "returns true" do
          report = create :report
          create :change, change_type: "change_in_hours", report: report
          create :navigator, has_new_job_documents: :unfilled, report: report

          expect(ShowRules.show_for_change_in_hours(report)).to eq(true)
        end
      end

      context "required has_change_in_hours_documents is already answered" do
        it "returns false" do
          report = create :report
          create :change, change_type: "change_in_hours", report: report
          create :navigator, has_change_in_hours_documents: :no, report: report

          expect(ShowRules.show_for_change_in_hours(report)).to eq(false)
        end
      end
    end

    context "when report doesn't have change_in_hours change type" do
      it "returns false" do
        report = create(:report, :with_change, change_type: "job_termination")

        expect(ShowRules.show_for_change_in_hours(report)).to eq(false)
      end
    end
  end
end
