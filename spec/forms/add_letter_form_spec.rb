require "rails_helper"

RSpec.describe AddLetterForm do
  describe "validations" do
    context "when letters is provided" do
      it "is valid" do
        form = AddLetterForm.new(
          letters: ["best attribute"],
        )

        expect(form).to be_valid
      end
    end

    context "when letters is just the empty string that comes from the client" do
      it "is invalid" do
        form = AddLetterForm.new(
          letters: [""],
        )

        expect(form).not_to be_valid
        expect(form.errors[:letters]).to be_present
      end
    end

    context "when letters is not provided" do
      it "is invalid" do
        form = AddLetterForm.new(
          letters: nil,
        )

        expect(form).not_to be_valid
        expect(form.errors[:letters]).to be_present
      end
    end
  end

  describe "#save" do
    let(:change_report) { create :change_report }
    let(:file) { fixture_file_upload(Rails.root.join("spec", "fixtures", "image.jpg"), "image/jpg") }

    let(:valid_params) do
      {
        change_report: change_report,
        letters: ["", file],
      }
    end

    it "persists the values to the correct models excluding any empty values" do
      form = AddLetterForm.new(valid_params)
      form.valid?
      form.save

      change_report.reload

      expect(change_report.letters.count).to eq 1
    end
  end
end
