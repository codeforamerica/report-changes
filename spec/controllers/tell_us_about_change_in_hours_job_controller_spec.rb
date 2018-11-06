require "rails_helper"

RSpec.describe TellUsAboutChangeInHoursJobController do
  it_behaves_like "form controller base behavior"
  it_behaves_like "form controller successful update", {
    company_name: "Abc Corp",
    manager_name: "My Boss",
    manager_phone_number: "111-222-3333",
  }
  it_behaves_like "form controller unsuccessful update"
  it_behaves_like "form controller shows when change in hours"
end
