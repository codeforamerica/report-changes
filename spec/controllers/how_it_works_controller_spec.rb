require "rails_helper"

RSpec.describe HowItWorksController do
  it_behaves_like "form controller base behavior"
  it_behaves_like "form controller always shows"

  describe "edit" do
    context "without current change report" do
      it "renders edit without redirect" do
        get :edit

        expect(response).to render_template(:edit)
      end
    end
  end
end
