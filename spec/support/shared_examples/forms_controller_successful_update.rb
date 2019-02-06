require "rails_helper"

RSpec.shared_examples_for "form controller successful update" do |valid_params, change_type|
  describe "#update" do
    context "without change report" do
      it "redirects to homepage" do
        session[:current_report_id] = nil

        put :update, params: { form: valid_params }

        expect(response).to redirect_to(root_path)
      end
    end

    context "with change report" do
      context "on successful update" do
        let(:report) { create :report, :filled, change_type: change_type }

        before do
          session[:current_report_id] = report.id
        end

        it "redirects to next path" do
          put :update, params: { form: valid_params }

          expect(response).to redirect_to(subject.next_path)
        end

        it "calls the mixpanel service" do
          mock_mixpanel_service = spy(MixpanelService)
          fake_analytics_data = { foo: "bar" }

          allow(MixpanelService).to receive(:instance).and_return(mock_mixpanel_service)
          allow(AnalyticsData).to receive(:new).with(report) { fake_analytics_data }

          put :update, params: { form: valid_params }

          report.reload
          expect(mock_mixpanel_service).to have_received(:run).with(
            unique_id: report.id,
            event_name: controller.form_class.analytics_event_name,
            data: fake_analytics_data,
          )
        end
      end
    end
  end
end
