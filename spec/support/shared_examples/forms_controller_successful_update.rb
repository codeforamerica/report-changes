require "rails_helper"

RSpec.shared_examples_for "form controller successful update" do |valid_params|
  describe "#update" do
    context "without change report" do
      it "redirects to homepage" do
        put :update, params: { form: valid_params }

        expect(response).to redirect_to(root_path)
      end
    end

    context "with change report" do
      let(:current_report) { create(:report, :with_navigator, :with_member, :with_metadata, :with_change) }

      before do
        session[:current_report_id] = current_report.id
      end

      context "on successful update" do
        it "redirects to next path" do
          put :update, params: { form: valid_params }

          expect(response).to redirect_to(subject.next_path)
        end

        it "calls the mixpanel service" do
          mock_mixpanel_service = spy(MixpanelService)
          fake_analytics_data = { foo: "bar" }

          allow(MixpanelService).to receive(:instance).and_return(mock_mixpanel_service)
          allow(AnalyticsData).to receive(:new).with(current_report) { fake_analytics_data }

          put :update, params: { form: valid_params }

          current_report.reload
          expect(mock_mixpanel_service).to have_received(:run).with(
            unique_id: current_report.id,
            event_name: controller.form_class.analytics_event_name,
            data: fake_analytics_data,
          )
        end
      end
    end
  end
end
