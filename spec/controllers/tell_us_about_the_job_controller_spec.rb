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
  it_behaves_like "form controller always shows"
end
