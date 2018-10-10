require "rails_helper"

RSpec.describe ChangeTypeForm do
  describe "validations" do
    context "when change_type is provided" do
      it "is valid" do
        form = ChangeTypeForm.new(nil, change_type: :job_termination)

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
    let(:change_report) { create :change_report }

    let(:valid_params) do
      {
        change_type: "job_termination",
      }
    end

    it "persists the values to the correct models" do
      form = ChangeTypeForm.new(change_report, valid_params)
      form.valid?
      form.save

      change_report.reload

      expect(change_report.change_type_job_termination?).to be_truthy
    end
  end

  describe ".from_change_report" do
    it "assigns values from change report" do
      change_report = create(:change_report, change_type: "new_job")

      form = ChangeTypeForm.from_change_report(change_report)

      expect(form.change_type).to eq "new_job"
    end
  end
end
