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

  describe "#save" do
    let(:valid_params) do
      {
        selected_county_location: :arapahoe,
      }
    end

    context "with an existing change report" do
      it "updates the navigator" do
        change_report = create :change_report,
                               navigator: build(:change_report_navigator, selected_county_location: :not_sure)
        valid_params[:change_report] = change_report
        form = CountyLocationForm.new(valid_params)
        form.valid?

        expect do
          form.save
        end.to_not(change { ChangeReport.count })

        expect(ChangeReport.last.navigator.selected_county_location_arapahoe?).to eq(true)
      end
    end

    context "when there is no change report yet" do
      it "creates the change report and navigator" do
        form = CountyLocationForm.new(valid_params)
        form.valid?

        expect do
          form.save
        end.to(change { ChangeReport.count }.from(0).to(1))

        expect(ChangeReport.last.navigator.selected_county_location_arapahoe?).to eq(true)
      end
    end
  end
end
