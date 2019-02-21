require "rails_helper"

RSpec.shared_examples_for "form controller new job behavior" do
  it_behaves_like "form controller base behavior", "new_job"

  describe "show?" do
    let(:report) { create :report, :filled, change_type: "new_job" }

    context "when change_type is new job" do
      it "returns true" do
        show_form = subject.class.show?(report)
        expect(show_form).to eq(true)
      end
    end

    context "when change_type is not new_job" do
      it "returns false" do
        report.current_change.update change_type: "change_in_hours"

        show_form = subject.class.show?(report)
        expect(show_form).to eq(false)
      end
    end
  end
end
