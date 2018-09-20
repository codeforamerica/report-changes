require "rails_helper"

RSpec.describe WhereDoYouLiveController do
  it_behaves_like "form controller base behavior"
  it_behaves_like "form controller successful update", {
    zip_code: "11111",
    city: "Littleton",
    street_address: "123 Main St",
  }
  it_behaves_like "form controller unsuccessful update"

  describe "show?" do
    context "when the client lives in Arapahoe County" do
      it "returns false" do
        navigator = build(:change_report_navigator, selected_county_location: :arapahoe)
        change_report = create(:change_report, navigator: navigator)

        show_form = WhereDoYouLiveController.show?(change_report)
        expect(show_form).to eq(false)
      end
    end

    context "when the client does not live in Arapahoe County" do
      it "returns false" do
        navigator = build(:change_report_navigator, selected_county_location: :not_arapahoe)
        change_report = create(:change_report, navigator: navigator)

        show_form = WhereDoYouLiveController.show?(change_report)
        expect(show_form).to eq(false)
      end
    end

    context "when the client doesn't know if they live in Arapahoe County" do
      it "returns true" do
        navigator = build(:change_report_navigator, selected_county_location: :not_sure)
        change_report = create(:change_report, navigator: navigator)

        show_form = WhereDoYouLiveController.show?(change_report)
        expect(show_form).to eq(true)
      end
    end
  end

  describe "#edit" do
    it "assigns the fields to the form" do
      current_change_report = create(:change_report)
      create(
        :change_report_navigator,
        change_report: current_change_report,
        street_address: "123 Main St",
        city: "Springfield",
        zip_code: "12345",
      )
      session[:current_change_report_id] = current_change_report.id

      get :edit

      form = assigns(:form)

      expect(form.street_address).to eq("123 Main St")
      expect(form.city).to eq("Springfield")
      expect(form.zip_code).to eq("12345")
    end
  end
end
