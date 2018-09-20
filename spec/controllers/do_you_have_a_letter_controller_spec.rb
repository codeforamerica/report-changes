require "rails_helper"

RSpec.describe DoYouHaveALetterController do
  it_behaves_like "form controller base behavior"
  it_behaves_like "form controller successful update", { has_letter: "yes" }
  it_behaves_like "form controller unsuccessful update"
  it_behaves_like "form controller always shows"

  describe "edit" do
    it "assigns existing attributes" do
      current_change_report = create(:change_report, navigator: build(:change_report_navigator, has_letter: "yes"))
      session[:current_change_report_id] = current_change_report.id

      get :edit

      form = assigns(:form)

      expect(form.has_letter).to eq("yes")
    end
  end
end
