require "rails_helper"

RSpec.shared_examples_for "form controller base behavior" do |is_last_section|
  context "with session" do
    let(:current_report) { create(:report, :with_navigator, :with_metadata) }

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
        form_navigation = FormNavigation.new(controller)

        if is_last_section
          expect(controller.next_path).to eq "/screens/#{controller.class.to_param}"
        else
          expect(controller.next_path).to eq "/screens/#{form_navigation.next.to_param}"
        end
      end
    end
  end
end
