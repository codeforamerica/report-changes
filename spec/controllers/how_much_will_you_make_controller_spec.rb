require "rails_helper"

RSpec.describe HowMuchWillYouMakeController do
  it_behaves_like "form controller successful update", {
    hourly_wage: "9.50",
    same_hours: "yes",
    same_hours_a_week_amount: "twenty",
    paid_how_often: "Every two weeks",
    first_paycheck_day: "15",
    first_paycheck_month: "1",
    first_paycheck_year: "2018",
    new_job_notes: "Those extra hours were only for one week",
  }, "new_job"
  it_behaves_like "form controller unsuccessful update"
  it_behaves_like "form controller new job behavior"
end
