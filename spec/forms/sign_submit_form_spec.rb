require "rails_helper"

RSpec.describe SignSubmitForm do
  describe "validations" do
    context "when signature is provided" do
      it "is valid" do
        form = SignSubmitForm.new(
          signature: "best person",
        )

        expect(form).to be_valid
      end
    end

    context "when no signature is provided" do
      it "is invalid" do
        form = SignSubmitForm.new(
          signature: nil,
        )

        expect(form).to_not be_valid
      end
    end
  end
end
