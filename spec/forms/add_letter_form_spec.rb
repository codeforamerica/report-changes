require "rails_helper"

RSpec.describe AddLetterForm do
  describe "#save" do
    let(:change_report) { create :change_report }
    let(:active_storage_blob) do
      ActiveStorage::Blob.create_after_upload!(
        io: File.open(Rails.root.join("spec", "fixtures", "image.jpg")),
        filename: "image.jpg",
        content_type: "image/jpg",
      )
    end

    let(:valid_params) do
      {
        change_report: change_report,
        letters: ["", active_storage_blob.signed_id],
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
      change_report.letters.attach(active_storage_blob)
      valid_params[:letters] = [change_report.letters.first.signed_id]

      form = AddLetterForm.new(valid_params)
      form.valid?

      expect do
        form.save
      end.to_not(change { change_report.letters.count })
    end

    it "removes values that are not included anymore" do
      change_report.letters.attach(active_storage_blob)
      valid_params[:letters] = []

      form = AddLetterForm.new(valid_params)
      form.valid?

      expect do
        form.save
      end.to(change { change_report.letters.count }.from(1).to(0))
    end
  end
end
