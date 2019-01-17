require "rails_helper"

RSpec.describe WantACopyController do
  it_behaves_like "form controller base behavior"
  it_behaves_like "form controller successful update", {
    email: "email@example.com",
  }
  it_behaves_like "form controller always shows"
end
