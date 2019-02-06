require "rails_helper"

RSpec.describe WhatCountyForm do
  let(:report) { create :report, :filled }

  describe "#save" do
    let(:valid_params) do
      {
        what_county: "A different county",
      }
    end

    it "persists the values to the correct models" do
      form = WhatCountyForm.new(report, valid_params)
      form.valid?
      form.save

      report.reload

      expect(report.metadata.what_county).to eq "A different county"
    end
  end

  describe ".from_report" do
    it "assigns values from change report" do
      report.metadata.update what_county: "A even more different county"

      form = WhatCountyForm.from_report(report)

      expect(form.what_county).to eq "A even more different county"
    end
  end
end
