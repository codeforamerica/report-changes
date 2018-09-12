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
end
