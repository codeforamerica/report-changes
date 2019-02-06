require "rails_helper"

RSpec.describe SuccessForm do
  let(:report) { create :report, :filled }

  describe "validations" do
    it "is invalid without feedback rating or comments" do
      form = SuccessForm.new(report)

      expect(form).not_to be_valid
      expect(form.errors[:feedback_rating]).to be_present
    end

    it "is valid with feedback rating" do
      form = SuccessForm.new(report, feedback_rating: "positive")

      expect(form).to be_valid
      expect(form.errors[:feedback_rating]).to_not be_present
    end

    it "is valid with feedback comments" do
      form = SuccessForm.new(report, feedback_comments: "best application ever")

      expect(form).to be_valid
      expect(form.errors[:feedback_rating]).to_not be_present
    end
  end

  describe "#save" do
    let(:valid_params) do
      {
        feedback_rating: "positive",
        feedback_comments: "what helpful tests!",
      }
    end

    it "persists the values to the correct models" do
      form = SuccessForm.new(report, valid_params)
      form.valid?
      form.save

      report.reload

      expect(report.metadata.feedback_rating).to eq("positive")
      expect(report.metadata.feedback_comments).to eq("what helpful tests!")
    end
  end
end
