require "rails_helper"

RSpec.describe TellUsMoreAboutTheLostJobController do
  it_behaves_like "form controller successful update", {
    last_day_day: "15",
    last_day_month: "1",
    last_day_year: "2000",
    last_paycheck_day: "28",
    last_paycheck_month: "2",
    last_paycheck_year: "2018",
  }
  it_behaves_like "form controller unsuccessful update"
  it_behaves_like "form controller job termination behavior"
end
