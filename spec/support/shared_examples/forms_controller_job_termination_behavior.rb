require "rails_helper"

RSpec.shared_examples_for "form controller job termination behavior" do
  it_behaves_like "form controller base behavior", "job_termination"

  describe "show?" do
    context "when change_type is job_termination" do
      it "returns true" do
        report = create(:report, :with_change, change_type: "job_termination")

        show_form = subject.class.show?(report)
        expect(show_form).to eq(true)
      end
    end

    context "when change_type is new_job" do
      it "returns false" do
        report = create(:report, :with_change, change_type: "new_job")

        show_form = subject.class.show?(report)
        expect(show_form).to eq(false)
      end
    end
  end
end
