require "rails_helper"

RSpec.describe DoYouHaveLostJobDocumentsController do
  it_behaves_like "form controller job termination behavior"
  it_behaves_like "form controller successful update", { has_job_termination_documents: "yes" } # , "job_termination"
  it_behaves_like "form controller unsuccessful update"
end
