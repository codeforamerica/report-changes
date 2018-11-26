require "rails_helper"

RSpec.describe ChangeTypeController do
  it_behaves_like "form controller base behavior"
  it_behaves_like "form controller successful update", {
    change_type: "job_termination",
  }
  it_behaves_like "form controller unsuccessful update"
  it_behaves_like "form controller always shows"
end
