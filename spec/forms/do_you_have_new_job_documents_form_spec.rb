require "rails_helper"

RSpec.describe DoYouHaveNewJobDocumentsForm do
  describe "validations" do
    context "when has_new_job_documents is provided" do
      it "is valid" do
        form = DoYouHaveNewJobDocumentsForm.new(
          nil,
          has_new_job_documents: "yes",
        )

        expect(form).to be_valid
      end
    end

    context "when has_new_job_documents is not provided" do
      it "is invalid" do
        form = DoYouHaveNewJobDocumentsForm.new(
          nil,
          has_new_job_documents: nil,
        )

        expect(form).not_to be_valid
        expect(form.errors[:has_new_job_documents]).to be_present
      end
    end
  end

  describe "#save" do
    let(:report) { create :report, :with_navigator }

    let(:valid_params) do
      {
        has_new_job_documents: "yes",
      }
    end

    it "persists the values to the correct models" do
      form = DoYouHaveNewJobDocumentsForm.new(report, valid_params)
      form.valid?
      form.save

      report.reload

      expect(report.navigator.has_new_job_documents_yes?).to be_truthy
    end
  end

  describe ".from_report" do
    it "assigns values from change report" do
      report = create(:report, :with_navigator, has_new_job_documents: "yes")

      form = DoYouHaveNewJobDocumentsForm.from_report(report)

      expect(form.has_new_job_documents).to eq("yes")
    end
  end
end
