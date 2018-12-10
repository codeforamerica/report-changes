require "rails_helper"

RSpec.describe TellUsAboutTheLostJobController do
  it_behaves_like "form controller successful update", {
    company_name: "Abc Corp",
  }
  it_behaves_like "form controller unsuccessful update"
  it_behaves_like "form controller job termination behavior"
end
