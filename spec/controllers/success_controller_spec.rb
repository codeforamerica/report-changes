require "rails_helper"

RSpec.describe SuccessController do
  it_behaves_like "form controller always shows"

  context "with session" do
    let(:current_report) do
      create(:report, :with_navigator, :with_metadata, :with_change)
    end

    before do
      session[:current_report_id] = current_report.id
    end

    describe "#current_report" do
      it "returns the ChangeReport from the id in the session" do
        expect(controller.current_report).to eq current_report
      end
    end

    describe "#edit" do
      it "sets the form and renders the template" do
        get :edit

        expect(response).to render_template(:edit)
        expect(assigns[:form]).to be_a Form
      end
    end

    describe "#current_path" do
      it "returns the path for this route" do
        expect(controller.current_path).to eq "/screens/#{controller.class.to_param}"
      end
    end

    describe "#next_path" do
      it "returns the next path from this controller" do
        expect(controller.next_path).to eq "/screens/#{controller.class.to_param}"
      end
    end
  end
end
