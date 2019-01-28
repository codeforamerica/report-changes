require "rails_helper"

RSpec.describe DoYouHaveNewJobDocumentsController do
  it_behaves_like "form controller new job behavior"
  it_behaves_like "form controller successful update", { has_new_job_documents: "yes" }, "new_job"
  it_behaves_like "form controller unsuccessful update"
end
