require "rails_helper"

RSpec.describe WhatKindOfProofController do
  it_behaves_like "form controller base behavior"
  it_behaves_like "form controller successful update", {
    has_offer_letter: "yes",
    has_paystub: "no",
  }
  it_behaves_like "form controller shows when new job"
end
