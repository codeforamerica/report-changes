require "rails_helper"

RSpec.describe WhatIsYourZipCodeForm do
  describe "validations" do
    context "when zip_code is provided" do
      it "is valid" do
        form = WhatIsYourZipCodeForm.new(
          nil,
          zip_code: "99999",
        )

        expect(form).to be_valid
      end
    end

    context "when zip_code is not provided" do
      it "is invalid" do
        form = WhatIsYourZipCodeForm.new(
          nil,
          zip_code: nil,
        )

        expect(form).not_to be_valid
        expect(form.errors[:zip_code]).to be_present
      end
    end
  end

  describe "#save" do
    context "single county zipcode" do
      let(:valid_params) do
        {
          zip_code: "80046",
        }
      end

      it "persists the values to the correct models" do
        form = WhatIsYourZipCodeForm.new(nil, valid_params)
        form.valid?
        form.save

        report = Report.last

        expect(report.navigator.zip_code).to eq "80046"
        expect(report.county).to eq "Arapahoe"
      end
    end

    context "overlapping county zipcode" do
      let(:valid_params) do
        {
          zip_code: "80741",
        }
      end

      it "persists the values to the correct models" do
        form = WhatIsYourZipCodeForm.new(nil, valid_params)
        form.valid?
        form.save

        report = Report.last

        expect(report.navigator.overlapping_zip?).to be_truthy
        expect(report.county).to be_nil
      end
    end
  end

  describe ".from_report" do
    it "assigns values from change report" do
      report = create :report
      create :navigator, report: report, zip_code: "80046"

      form = WhatIsYourZipCodeForm.from_report(report)

      expect(form.zip_code).to eq("80046")
    end
  end
end
