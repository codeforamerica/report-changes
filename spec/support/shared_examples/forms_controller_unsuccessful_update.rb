require "rails_helper"

RSpec.shared_examples_for "form controller unsuccessful update" do |invalid_params|
  describe "#update" do
    context "on unsucessful update" do
      it "rerenders edit template" do
        current_change_report = create(:change_report, :with_navigator)
        session[:current_change_report_id] = current_change_report.id

        put :update, params: { form: invalid_params || {} }

        expect(response).to render_template(:edit)
      end
    end
  end
end
