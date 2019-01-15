require "rails_helper"

RSpec.describe WhatCountyController do
  it_behaves_like "form controller base behavior"
  it_behaves_like "form controller successful update", {
    what_county: "A different county",
  }

  describe "#show" do
    it "shows when user doesn't live in arapahoe county" do
      report = create :report, navigator: build(:navigator, selected_county_location: :not_arapahoe)

      expect(WhatCountyController.show?(report)).to eq(true)
    end

    it "does not show when user lives in arapahoe county" do
      report = create :report, navigator: build(:navigator, selected_county_location: :arapahoe)

      expect(WhatCountyController.show?(report)).to eq(false)
    end
  end
end
