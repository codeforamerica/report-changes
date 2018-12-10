require "rails_helper"

RSpec.describe TellUsAboutChangeInHoursController do
  it_behaves_like "form controller successful update", {
    lower_hours_a_week_amount: 20,
    change_date_day: "15",
    change_date_month: "1",
    change_date_year: "2018",
    hourly_wage: "10",
    paid_how_often: "Every two weeks",
    change_in_hours_notes: "My notes",
  }, "change_in_hours"
  it_behaves_like "form controller unsuccessful update"
  it_behaves_like "form controller change in hours behavior"
end
