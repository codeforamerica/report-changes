require "rails_helper"

RSpec.describe TellUsAboutYourselfController do
  it_behaves_like "form controller base behavior"
  it_behaves_like "form controller successful update", {
    name: "Jane Doe",
    phone_number: "111-222-3333",
    ssn: "111-22-3333",
    case_number: "123abc",
    birthday_day: "15",
    birthday_month: "1",
    birthday_year: "2000",
  }
  it_behaves_like "form controller unsuccessful update"
  it_behaves_like "form controller always shows"

  describe "#edit" do
    it "assigns the fields to the form" do
      current_change_report = create(:change_report,
                                     :with_navigator,
                                     case_number: "1A1234",
                                     phone_number: "1234567890",
                                     member: build(:household_member,
                                              name: "Jane Doe",
                                              ssn: "111223333",
                                              birthday: DateTime.new(1950, 1, 31)))

      session[:current_change_report_id] = current_change_report.id

      get :edit

      form = assigns(:form)

      expect(form.name).to eq("Jane Doe")
      expect(form.birthday_year).to eq(1950)
      expect(form.birthday_month).to eq(1)
      expect(form.birthday_day).to eq(31)
      expect(form.phone_number).to eq("1234567890")
      expect(form.ssn).to eq("111223333")
      expect(form.case_number).to eq("1A1234")
    end
  end
end
