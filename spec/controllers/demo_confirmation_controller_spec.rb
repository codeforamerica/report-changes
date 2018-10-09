require "rails_helper"

RSpec.describe DemoConfirmationController do
  it_behaves_like "form controller base behavior"

  describe "show?" do
    context "when rails is a demo environment" do
      it "returns true" do
        allow(GateKeeper).to receive(:demo_environment?).and_return(true)

        show_form = DemoConfirmationController.show?(nil)
        expect(show_form).to eq(true)
      end
    end

    context "when rails is not a demo environment" do
      it "returns false" do
        show_form = DemoConfirmationController.show?(nil)
        expect(show_form).to eq(false)
      end
    end
  end

  describe "edit" do
    context "without current change report" do
      it "renders edit without redirect" do
        get :edit

        expect(response).to render_template(:edit)
      end
    end
  end
end
