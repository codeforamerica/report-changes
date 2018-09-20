require "rails_helper"

RSpec.describe TellUsAboutTheJobController do
  it_behaves_like "form controller base behavior"
  it_behaves_like "form controller successful update", {
    company_name: "Abc Corp",
    company_address: "123 Main St Denver",
    company_phone_number: "111-222-3333",
    last_day_day: "15",
    last_day_month: "1",
    last_day_year: "2000",
    last_paycheck_day: "28",
    last_paycheck_month: "2",
    last_paycheck_year: "2018",
  }
  it_behaves_like "form controller unsuccessful update"

  describe "#edit" do
    it "assigns the fields to the form" do
      current_change_report = create(:change_report,
                                     :with_navigator,
                                     company_name: "Abc Corp",
                                     company_address: "123 Main St Denver",
                                     company_phone_number: "1112223333",
                                     last_day: DateTime.new(2000, 1, 15),
                                     last_paycheck: DateTime.new(2018, 2, 28))

      session[:current_change_report_id] = current_change_report.id

      get :edit

      form = assigns(:form)

      expect(form.company_name).to eq("Abc Corp")
      expect(form.company_address).to eq("123 Main St Denver")
      expect(form.company_phone_number).to eq("1112223333")
      expect(form.last_day_year).to eq(2000)
      expect(form.last_day_month).to eq(1)
      expect(form.last_day_day).to eq(15)
      expect(form.last_paycheck_year).to eq(2018)
      expect(form.last_paycheck_month).to eq(2)
      expect(form.last_paycheck_day).to eq(28)
    end
  end
end
