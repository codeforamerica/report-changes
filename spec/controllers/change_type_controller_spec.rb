require "rails_helper"

RSpec.describe ChangeTypeController do
  it_behaves_like "form controller base behavior"
  it_behaves_like "form controller successful update", {
    change_type: "job_termination",
  }
  it_behaves_like "form controller unsuccessful update"

  describe "#show" do
    context "there are unreported change types available" do
      it "it shows" do
        report = create :report, :with_navigator, reported_changes: []

        expect(ChangeTypeController.show?(report)).to eq(true)
      end
    end

    context "all change types have been reported" do
      it "it shows" do
        report = create :report, :with_navigator
        create :change, change_type: :job_termination, report: report
        create :change, change_type: :new_job, report: report
        create :change, change_type: :change_in_hours, report: report

        expect(ChangeTypeController.show?(report)).to eq(false)
      end
    end
  end

  describe "#collection_of_unreported_change_types" do
    context "no changes reported yet" do
      it "all change types are available" do
        report = create :report, :with_navigator
        session[:current_report_id] = report.id

        full_collection = [
          { value: :job_termination, label: "My job ended or I stopped working" },
          { value: :new_job, label: "I started a new job" },
          { value: :change_in_hours, label: "My hours or pay changed" },
        ]

        expect(controller.collection_of_unreported_change_types).to eq full_collection
      end
    end

    context "one change reported so far" do
      it "the other two change types are available" do
        report = create :report, :with_navigator
        create :change, change_type: :job_termination, report: report
        session[:current_report_id] = report.id

        collection = [
          { value: :new_job, label: "I started a new job" },
          { value: :change_in_hours, label: "My hours or pay changed" },
        ]

        expect(controller.collection_of_unreported_change_types).to eq collection
      end
    end

    context "all changes reported so far, page shouldn't show" do
      it "an empty array" do
        report = create :report, :with_navigator
        create :change, change_type: :job_termination, report: report
        create :change, change_type: :new_job, report: report
        create :change, change_type: :change_in_hours, report: report
        session[:current_report_id] = report.id

        collection = []

        expect(controller.collection_of_unreported_change_types).to eq collection
      end
    end
  end
end
