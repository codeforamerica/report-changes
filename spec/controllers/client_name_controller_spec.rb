require "rails_helper"

RSpec.describe ClientNameController do
  it_behaves_like "form controller base behavior"
  it_behaves_like "form controller successful update", {
    first_name: "Best",
    last_name: "Person",
  }
  it_behaves_like "form controller unsuccessful update"
  it_behaves_like "form controller always shows"
end
