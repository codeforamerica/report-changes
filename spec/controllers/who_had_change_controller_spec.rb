require "rails_helper"

RSpec.describe WhoHadChangeController do
  it_behaves_like "form controller base behavior"
  it_behaves_like "form controller successful update", {
    submitting_for: "self",
  }
  it_behaves_like "form controller unsuccessful update"
  it_behaves_like "form controller always shows"
end
