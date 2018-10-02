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
      let(:current_change_report) { create(:change_report, :with_navigator, :with_member) }

      before do
        session[:current_change_report_id] = current_change_report.id
      end

      context "on successful update" do
        it "redirects to next path" do
          put :update, params: { form: valid_params }

          expect(response).to redirect_to(subject.next_path)
        end
      end
    end
  end
end
