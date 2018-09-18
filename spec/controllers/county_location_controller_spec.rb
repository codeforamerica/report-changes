require "rails_helper"

RSpec.describe CountyLocationController do
  it_behaves_like "form controller"

  describe "show?" do
    it "is always true" do
      show_form = CountyLocationController.show?(nil)
      expect(show_form).to eq(true)
    end
  end

  describe "edit" do
    context "with an existing change report" do
      it "assigns existing attributes" do
        current_change_report = create(:change_report)
        create(:change_report_navigator,
               change_report: current_change_report,
               selected_county_location: "arapahoe")
        session[:current_change_report_id] = current_change_report.id

        get :edit

        form = assigns(:form)

        expect(form.selected_county_location).to eq("arapahoe")
      end
    end

    context "without a change report" do
      it "renders edit" do
        get :edit

        form = assigns(:form)

        expect(response).to render_template(:edit)
        expect(form.selected_county_location).to be_nil
      end
    end
  end

  describe "#update" do
    context "with valid params" do
      let(:valid_params) do
        {
          selected_county_location: "arapahoe",
        }
      end

      context "with an existing change report and navigator" do
        it "redirects to next path and updates the change report" do
          current_change_report = create(:change_report, :with_navigator)
          session[:current_change_report_id] = current_change_report.id

          put :update, params: { form: valid_params }

          current_change_report.reload

          expect(response).to redirect_to(subject.next_path)
          expect(current_change_report.navigator.selected_county_location_arapahoe?).to be_truthy
        end
      end

      context "without an existing change report" do
        it "redirects to next path and creates the change report" do
          put :update, params: { form: valid_params }
          current_change_report = ChangeReport.find(session[:current_change_report_id])

          expect(response).to redirect_to(subject.next_path)
          expect(current_change_report.navigator.selected_county_location_arapahoe?).to be_truthy
        end
      end
    end

    context "with invalid params" do
      let(:invalid_params) do
        {
          selected_county_location: nil,
        }
      end

      it "renders edit" do
        put :update, params: { form: invalid_params }

        expect(response).to render_template(:edit)
      end
    end
  end
end
