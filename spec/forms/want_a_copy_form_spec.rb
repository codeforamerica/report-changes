require "rails_helper"

RSpec.describe WantACopyForm do
  let(:report) { create :report, :filled }

  describe "#save" do
    let(:valid_params) do
      {
        email: "fake@example.com",
      }
    end

    it "persists the values to the correct models" do
      form = WantACopyForm.new(report, valid_params)
      form.valid?
      form.save

      report.reload

      expect(report.metadata.email).to eq "fake@example.com"
    end
  end

  describe ".from_report" do
    it "assigns values from change report" do
      report.metadata.update email: "fake@example.com"

      form = WantACopyForm.from_report(report)

      expect(form.email).to eq "fake@example.com"
    end
  end
end
