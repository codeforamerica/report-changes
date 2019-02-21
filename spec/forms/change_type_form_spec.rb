require "rails_helper"

RSpec.describe ChangeTypeForm do
  describe "validations" do
    context "when selected_change_type is provided" do
      it "is valid" do
        form = ChangeTypeForm.new(nil, selected_change_type: "job_termination")

        expect(form).to be_valid
      end
    end

    context "when selected_change_type is not provided" do
      it "is invalid" do
        form = ChangeTypeForm.new(nil, selected_change_type: nil)
        expect(form).not_to be_valid
        expect(form.errors[:selected_change_type]).to be_present
      end
    end
  end
end
