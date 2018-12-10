require "rails_helper"

RSpec.describe SelfEmployedController do
  it_behaves_like "form controller successful update", {
    is_self_employed: "no",
  }
  it_behaves_like "form controller unsuccessful update"
  it_behaves_like "form controller new job behavior"
end
