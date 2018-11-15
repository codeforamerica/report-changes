require "rails_helper"

RSpec.describe SuccessForm do
  describe "validations" do
    let(:change_report) { create :change_report, :with_metadata }

    it "is invalid without feedback rating or comments" do
      form = SuccessForm.new(change_report)

      expect(form).not_to be_valid
      expect(form.errors[:feedback_rating]).to be_present
    end

    it "is valid with feedback rating" do
      form = SuccessForm.new(change_report, feedback_rating: "positive")

      expect(form).to be_valid
      expect(form.errors[:feedback_rating]).to_not be_present
    end

    it "is valid with feedback comments" do
      form = SuccessForm.new(change_report, feedback_comments: "best application ever")

      expect(form).to be_valid
      expect(form.errors[:feedback_rating]).to_not be_present
    end
  end

  describe "#save" do
    let(:change_report) { create :change_report, :with_metadata }

    let(:valid_params) do
      {
        feedback_rating: "positive",
        feedback_comments: "what helpful tests!",
      }
    end

    it "persists the values to the correct models" do
      form = SuccessForm.new(change_report, valid_params)
      form.valid?
      form.save

      change_report.reload

      expect(change_report.metadata.feedback_rating).to eq("positive")
      expect(change_report.metadata.feedback_comments).to eq("what helpful tests!")
    end
  end
end
