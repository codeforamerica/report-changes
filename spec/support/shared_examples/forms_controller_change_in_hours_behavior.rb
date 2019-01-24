require "rails_helper"

RSpec.shared_examples_for "form controller change in hours behavior" do
  it_behaves_like "form controller base behavior", "change_in_hours"

  describe "show?" do
    context "when change_type is change_in_hours" do
      it "returns true" do
        report = create(:report, :with_navigator, :with_change, change_type: "change_in_hours")

        show_form = subject.class.show?(report)
        expect(show_form).to eq(true)
      end
    end

    context "when change_type is new_job" do
      it "returns false" do
        report = create(:report, :with_navigator, :with_change, change_type: "new_job")

        show_form = subject.class.show?(report)
        expect(show_form).to eq(false)
      end
    end
  end
end
