require "rails_helper"

RSpec.describe WhatKindOfProofForm do
  describe "#save" do
    let(:change_report) { create :change_report, :with_navigator }

    let(:valid_params) do
      {
        has_offer_letter: "no",
        has_paystub: "no",
      }
    end

    it "persists the values to the correct models" do
      form = WhatKindOfProofForm.new(change_report, valid_params)
      form.valid?
      form.save

      change_report.reload

      expect(change_report.navigator.has_offer_letter).to eq "no"
      expect(change_report.navigator.has_paystub).to eq "no"
    end
  end
end
