require "rails_helper"

RSpec.describe StaticPagesController, type: :controller do
  context "with a current change report" do
    describe "#index" do
      it "sets the current change report id to nil" do
        session[:current_change_report_id] = 1

        get :index

        expect(session[:current_change_report_id]).to be_nil
      end
    end
  end
end