require "rails_helper"

RSpec.describe WhatCountyDoYouLiveInForm do
  describe "validations" do
    context "when county is provided" do
      it "is valid" do
        form = WhatCountyDoYouLiveInForm.new(
          nil,
          county: "Arapahoe",
        )

        expect(form).to be_valid
      end
    end

    context "when county is not provided" do
      it "is invalid" do
        form = WhatCountyDoYouLiveInForm.new(
          nil,
          county: nil,
        )

        expect(form).not_to be_valid
        expect(form.errors[:county]).to be_present
      end
    end
  end

  describe "#save" do
    let(:report) { create :report, :filled }

    let(:valid_params) do
      {
        county: "Arapahoe",
      }
    end

    it "persists the values to the correct models" do
      form = WhatCountyDoYouLiveInForm.new(report, valid_params)
      form.valid?
      form.save

      report.reload

      expect(report.county).to eq "Arapahoe"
    end
  end

  describe ".from_report" do
    it "assigns values from change report" do
      report = create(:report, county: "Arapahoe")

      form = WhatCountyDoYouLiveInForm.from_report(report)

      expect(form.county).to eq "Arapahoe"
    end
  end
end
