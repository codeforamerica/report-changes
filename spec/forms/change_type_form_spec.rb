require "rails_helper"

RSpec.describe ChangeTypeForm do
  describe "validations" do
    context "when change_type is provided" do
      it "is valid" do
        form = ChangeTypeForm.new(nil,
                                  job_termination: "1",
                                  new_job: "1",
                                  change_in_hours: "0")

        expect(form).to be_valid
      end
    end

    context "when change_type is not provided" do
      it "is invalid" do
        form = ChangeTypeForm.new(nil,
                                  job_termination: "0",
                                  new_job: "0",
                                  change_in_hours: "0")

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
          job_termination: "1",
          new_job: "1",
          change_in_hours: "0",
        }
      end

      it "creates a new change for each selected change type" do
        form = ChangeTypeForm.new(report, valid_params)
        form.valid?
        form.save

        report.reload

        expect(report.reported_changes.count).to eq(2)
        expect(report.reported_changes.map(&:change_type)).to match_array(["job_termination", "new_job"])
      end
    end

    context "when reported_change already exists" do
      let(:report) { create :report, :with_change, change_type: "new_job" }

      let(:valid_params) do
        {
          job_termination: "0",
          new_job: "1",
          change_in_hours: "0",
        }
      end

      it "does not create new change of same type" do
        form = ChangeTypeForm.new(report, valid_params)
        form.valid?

        expect do
          form.save
          report.reload
        end.to_not change { report.reported_changes.detect { |change| change.change_type == "new_job" }.id }
      end
    end

    context "a change for a given type already exists but is not selected" do
      let(:report) { create :report, :with_change, change_type: "new_job" }

      let(:valid_params) do
        {
          job_termination: "1",
          new_job: "0",
          change_in_hours: "0",
        }
      end

      it "removes the change of that type" do
        form = ChangeTypeForm.new(report, valid_params)
        form.valid?

        form.save
        report.reload

        expect(report.reported_changes.count).to eq(1)
        expect(report.reported_changes.map(&:change_type)).to match_array(["job_termination"])
      end
    end
  end

  describe ".from_report" do
    it "assigns values from change report" do
      report = create(:report, :with_change, change_type: "new_job")

      form = ChangeTypeForm.from_report(report)

      expect(form.new_job).to eq "1"
      expect(form.job_termination).to be_nil
      expect(form.change_in_hours).to be_nil
    end
  end
end
