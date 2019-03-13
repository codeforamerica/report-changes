require "rails_helper"

RSpec.describe WhatCountyDoYouLiveInController do
  it_behaves_like "form controller base behavior"
  it_behaves_like "form controller unsuccessful update"

  describe "#update" do
    context "on successful update" do
      it "redirects to next path" do
        put :update, params: { form: { county: "Arapahoe" } }

        expect(response).to redirect_to(subject.next_path)
      end
    end
  end
end
