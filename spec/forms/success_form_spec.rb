require "rails_helper"

RSpec.describe SuccessForm do
  describe "validations" do
    it "is invalid without feedback rating or comments" do
      form = SuccessForm.new

      expect(form).not_to be_valid
      expect(form.errors[:feedback_rating]).to be_present
    end

    it "is valid with feedback rating" do
      form = SuccessForm.new(feedback_rating: "positive")

      expect(form).to be_valid
      expect(form.errors[:feedback_rating]).to_not be_present
    end

    it "is valid with feedback comments" do
      form = SuccessForm.new(feedback_comments: "best application ever")

      expect(form).to be_valid
      expect(form.errors[:feedback_rating]).to_not be_present
    end
  end
end
