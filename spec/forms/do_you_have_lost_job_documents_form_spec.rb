require "rails_helper"

RSpec.describe DoYouHaveLostJobDocumentsForm do
  describe "validations" do
    context "when some_attribute is provided" do
      it "is valid" do
        form = DoYouHaveLostJobDocumentsForm.new(
          nil,
          has_job_termination_documents: "yes",
        )

        expect(form).to be_valid
      end
    end

    context "when has_job_termination_documents is not provided" do
      it "is invalid" do
        form = DoYouHaveLostJobDocumentsForm.new(
          nil,
          has_job_termination_documents: nil,
        )

        expect(form).not_to be_valid
        expect(form.errors[:has_job_termination_documents]).to be_present
      end
    end
  end

  describe "#save" do
    let(:report) { create :report, :with_navigator }

    let(:valid_params) do
      {
        has_job_termination_documents: "yes",
      }
    end

    it "persists the values to the correct models" do
      form = DoYouHaveLostJobDocumentsForm.new(report, valid_params)
      form.valid?
      form.save

      report.reload

      expect(report.navigator.has_job_termination_documents_yes?).to be_truthy
    end
  end

  describe ".from_report" do
    it "assigns values from change report" do
      report = create(:report, navigator: build(:navigator, has_job_termination_documents: "yes"))

      form = DoYouHaveLostJobDocumentsForm.from_report(report)

      expect(form.has_job_termination_documents).to eq("yes")
    end
  end
end
