require "rails_helper"

RSpec.describe WhereDoYouLiveForm do
  describe "validations" do
    let(:valid_params) do
      {
        zip_code: "11111",
        city: "Littleton",
        street_address: "123 Main St",
      }
    end

    context "when all params are valid" do
      it "is valid" do
        form = WhereDoYouLiveForm.new(valid_params)

        expect(form).to be_valid
      end
    end

    describe "zip code" do
      context "when no zip code is provided" do
        it "is invalid" do
          invalid_params = valid_params.merge(zip_code: nil)
          form = WhereDoYouLiveForm.new(invalid_params)

          expect(form).to_not be_valid
        end
      end

      context "when zip code is less than 5 digits long" do
        it "is invalid" do
          invalid_params = valid_params.merge(zip_code: nil)
          form = WhereDoYouLiveForm.new(invalid_params)

          expect(form).to_not be_valid
        end
      end
    end

    describe "city" do
      context "when city is not present" do
        it "is invalid" do
          invalid_params = valid_params.merge(city: nil)
          form = WhereDoYouLiveForm.new(invalid_params)

          expect(form).to_not be_valid
        end
      end
    end

    describe "street_address" do
      context "when street address is not present" do
        it "is invalid" do
          invalid_params = valid_params.merge(street_address: nil)
          form = WhereDoYouLiveForm.new(invalid_params)

          expect(form).to_not be_valid
        end
      end
    end
  end

  describe "#save" do
    let(:change_report) { create :change_report, :with_navigator }
    let(:valid_params) do
      {
        zip_code: "11111",
        city: "Littleton",
        street_address: "123 Main St",
        change_report: change_report,
      }
    end

    it "persists the values to the correct models" do
      county_finder = instance_double(CountyFinder)
      expect(CountyFinder).to receive(:new).with(
        street_address: "123 Main St",
        city: "Littleton",
        zip: "11111",
        state: "CO",
      ).and_return(county_finder)
      allow(county_finder).to receive(:run).and_return("Arapahoe")

      form = WhereDoYouLiveForm.new(valid_params)
      form.valid?
      form.save

      change_report.reload

      expect(change_report.navigator.zip_code).to eq "11111"
      expect(change_report.navigator.city).to eq "Littleton"
      expect(change_report.navigator.street_address).to eq "123 Main St"
      expect(change_report.navigator.county_from_address).to eq "Arapahoe"
    end
  end
end
