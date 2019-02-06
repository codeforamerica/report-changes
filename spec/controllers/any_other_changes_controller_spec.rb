require "rails_helper"

RSpec.describe AnyOtherChangesController do
  it_behaves_like "form controller base behavior"
  it_behaves_like "form controller always shows"

  describe "#update" do
    before do
      report = create :report, :filled
      session[:current_report_id] = report.id
    end

    context "yes they have more changes to report" do
      it "redirect to change type screen" do
        put :update, params: { form: { any_other_changes: "yes" } }

        expect(response).to redirect_to(change_type_screens_path)
      end
    end

    context "no more changes" do
      before { put :update, params: { form: { any_other_changes: "no" } } }

      it "keep going to next page" do
        expect(response).to redirect_to(want_a_copy_screens_path)
      end

      it "clears out current_member and current_change" do
        controller.current_report.reload

        expect(controller.current_report.navigator.current_member).to be_nil
        expect(controller.current_report.navigator.current_change).to be_nil
      end
    end
  end
end
