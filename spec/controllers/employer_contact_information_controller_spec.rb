require "rails_helper"

RSpec.describe EmployerContactInformationController do
  it_behaves_like "form controller base behavior"
  it_behaves_like "form controller successful update", {
    manager_name: "Best E. Person",
    manager_phone_number: "3334445555",
    manager_additional_information: "Something the case worker should know.",
  }
  it_behaves_like "form controller unsuccessful update"

  describe "show?" do
    context "when the client has a letter" do
      it "is false" do
        navigator = build(:change_report_navigator, has_letter: "yes")
        change_report = create(:change_report, navigator: navigator)
        expect(EmployerContactInformationController.show?(change_report)).to be_falsey
      end
    end

    context "when the client does not have a letter" do
      it "is true" do
        navigator = build(:change_report_navigator, has_letter: "no")
        change_report = create(:change_report, navigator: navigator)
        expect(EmployerContactInformationController.show?(change_report)).to be_truthy
      end
    end
  end

  describe "edit" do
    it "assigns existing attributes" do
      current_change_report = create(:change_report,
                                     :with_navigator,
                                     manager_name: "Princess Caroline",
                                     manager_phone_number: "5551119999",
                                     manager_additional_information: "She's a cat")

      session[:current_change_report_id] = current_change_report.id

      get :edit

      form = assigns(:form)

      expect(form.manager_name).to eq "Princess Caroline"
      expect(form.manager_phone_number).to eq "5551119999"
      expect(form.manager_additional_information).to eq "She's a cat"
    end
  end
end
