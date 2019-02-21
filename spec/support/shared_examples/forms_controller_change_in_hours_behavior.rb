require "rails_helper"

RSpec.shared_examples_for "form controller change in hours behavior" do
  it_behaves_like "form controller base behavior", "change_in_hours"

  describe "show?" do
    let(:report) { create :report, :filled, change_type: "change_in_hours" }

    context "when change_type is change_in_hours" do
      it "returns true" do
        show_form = subject.class.show?(report)
        expect(show_form).to eq(true)
      end
    end

    context "when change_type is new_job" do
      it "returns false" do
        report.current_change.update change_type: "new_job"

        show_form = subject.class.show?(report)
        expect(show_form).to eq(false)
      end
    end
  end
end
