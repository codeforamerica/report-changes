require "rails_helper"

RSpec.describe DoYouHaveDocumentsController do
  it_behaves_like "form controller change in hours behavior"
  it_behaves_like "form controller successful update", { has_change_in_hours_documents: "yes" }, "change_in_hours"
  it_behaves_like "form controller unsuccessful update"
end
