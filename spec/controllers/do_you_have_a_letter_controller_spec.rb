require "rails_helper"

RSpec.describe DoYouHaveALetterController do
  it_behaves_like "form controller base behavior"
  it_behaves_like "form controller successful update", { proof_types: nil }
  it_behaves_like "form controller unsuccessful update", { proof_types: ["foo"] }
  it_behaves_like "form controller shows when job termination"
end
