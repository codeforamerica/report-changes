require "rails_helper"
RSpec.describe CountyLocationForm do
  describe "validations" do
    context "when county location is provided" do
      it "is valid" do
        form = CountyLocationForm.new(
          selected_county_location: "arapahoe",
        )

        expect(form).to be_valid
      end
    end

    context "when no county location is provided" do
      it "is invalid" do
        form = CountyLocationForm.new(
          selected_county_location: nil,
        )

        expect(form).to_not be_valid
      end
    end
  end
end
