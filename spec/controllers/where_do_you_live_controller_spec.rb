require "rails_helper"

RSpec.describe WhereDoYouLiveController do
  it_behaves_like "form controller"

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

  describe "#update" do
    context "with valid params" do
      let(:valid_params) do
        {
          zip_code: "11111",
          city: "Littleton",
          street_address: "123 Main St",
        }
      end

      it "redirects to next path and updates the change report navigator" do
        current_change_report = create(:change_report, :with_navigator)
        session[:current_change_report_id] = current_change_report.id

        county_finder = instance_double(CountyFinder)
        expect(CountyFinder).to receive(:new).with(
          street_address: "123 Main St",
          city: "Littleton",
          zip: "11111",
          state: "CO",
        ).and_return(county_finder)
        allow(county_finder).to receive(:run).and_return("Arapahoe")

        put :update, params: { form: valid_params }

        current_change_report.reload

        expect(response).to redirect_to(subject.next_path)
        expect(current_change_report.navigator.street_address).to eq "123 Main St"
        expect(current_change_report.navigator.city).to eq "Littleton"
        expect(current_change_report.navigator.zip_code).to eq "11111"
        expect(current_change_report.navigator.county_from_address).to eq "Arapahoe"
      end
    end

    context "with invalid params" do
      let(:invalid_params) do
        {
          zip_code: nil,
          city: nil,
          street_address: nil,
        }
      end

      it "renders edit" do
        current_change_report = create(:change_report, :with_navigator)
        session[:current_change_report_id] = current_change_report.id

        put :update, params: { form: invalid_params }

        expect(response).to render_template(:edit)
      end
    end
  end

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
end
