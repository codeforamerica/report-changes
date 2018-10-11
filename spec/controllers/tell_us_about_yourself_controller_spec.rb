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
end
