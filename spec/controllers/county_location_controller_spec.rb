require "rails_helper"

RSpec.describe CountyLocationController do
  it_behaves_like "form controller base behavior"
  it_behaves_like "form controller always shows"

  describe "#update" do
    before do
      session[:source] = "awesome-cbo"
    end

    context "with valid params" do
      let(:valid_params) do
        {
          selected_county_location: "arapahoe",
        }
      end

      context "with an existing change report and navigator" do
        it "redirects to next path and updates the change report" do
          current_report = create(:report, :with_navigator)
          session[:current_report_id] = current_report.id

          put :update, params: { form: valid_params }

          current_report.reload

          expect(response).to redirect_to(subject.next_path)
          expect(current_report.navigator.selected_county_location_arapahoe?).to be_truthy
          expect(current_report.navigator.source).to eq "awesome-cbo"
        end
      end

      context "without an existing change report" do
        it "redirects to next path and creates the change report" do
          put :update, params: { form: valid_params }
          current_report = Report.find(session[:current_report_id])

          expect(response).to redirect_to(subject.next_path)
          expect(current_report.navigator.selected_county_location_arapahoe?).to be_truthy
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
