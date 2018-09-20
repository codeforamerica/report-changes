require "rails_helper"

RSpec.describe HowItWorksController do
  it_behaves_like "form controller base behavior"

  describe "show?" do
    it "is always true" do
      show_form = HowItWorksController.show?(nil)
      expect(show_form).to eq(true)
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
