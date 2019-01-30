require "rails_helper"

RSpec.describe ChangeTypeForm do
  describe "validations" do
    context "when change_type is provided" do
      it "is valid" do
        form = ChangeTypeForm.new(nil, change_type: "job_termination")

        expect(form).to be_valid
      end
    end

    context "when change_type is not provided" do
      it "is invalid" do
        form = ChangeTypeForm.new(nil, change_type: nil)
        expect(form).not_to be_valid
        expect(form.errors[:change_type]).to be_present
      end
    end
  end

  describe "#save" do
    context "when no reported_change exists yet" do
      let(:report) { create :report }

      let(:valid_params) do
        {
          change_type: "job_termination",
        }
      end

      it "creates a new change" do
        form = ChangeTypeForm.new(report, valid_params)
        form.save

        report.reload

        expect(report.reported_changes.pluck(:change_type)).to match_array(["job_termination"])
      end
    end

    context "when reported_change already exists" do
      let(:report) { create :report, :with_change, change_type: "new_job" }

      let(:valid_params) do
        {
          change_type: "new_job",
        }
      end

      it "creates another change" do
        form = ChangeTypeForm.new(report, valid_params)
        form.valid?

        expect do
          form.save
          report.reload
        end.to change { report.reported_changes.detect { |change| change.change_type == "new_job" }.id }
      end
    end
  end
end
