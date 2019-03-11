require "rails_helper"

RSpec.describe WhatIsYourZipCodeController do
  it_behaves_like "form controller base behavior"
  it_behaves_like "form controller unsuccessful update"
  it_behaves_like "form controller always shows"

  describe "#update" do
    context "on successful update" do
      it "redirects to next path" do
        put :update, params: { form: { zip_code: "80046" } }

        expect(response).to redirect_to(subject.next_path)
      end
    end
  end
end
