require "rails_helper"

RSpec.describe AnyOtherChangesForm do
  describe "validations" do
    context "when some_attribute is provided" do
      it "is valid" do
        form = AnyOtherChangesForm.new(
          nil,
          any_other_changes: "yes",
        )

        expect(form).to be_valid
      end
    end

    context "when some_attribute is not provided" do
      it "is invalid" do
        form = AnyOtherChangesForm.new(
          nil,
          any_other_changes: nil,
        )

        expect(form).not_to be_valid
        expect(form.errors[:any_other_changes]).to be_present
      end
    end
  end
end
