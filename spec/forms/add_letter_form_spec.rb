require "rails_helper"

RSpec.describe AddLetterForm do
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

    it "ignores values that are already present" do
      change_report.letters.attach(file)
      valid_params[:letters] = [change_report.letters.first.signed_id]

      form = AddLetterForm.new(valid_params)
      form.valid?

      expect do
        form.save
      end.to_not(change { change_report.letters.count })
    end
  end
end
