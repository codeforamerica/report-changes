require "rails_helper"

RSpec.describe DoYouHaveDocumentsController do
  it_behaves_like "form controller always shows"
  it_behaves_like "form controller successful update", { has_documents: "yes" }
  it_behaves_like "form controller unsuccessful update"
end
