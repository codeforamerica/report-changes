require "rails_helper"

RSpec.shared_examples_for "form controller shows when job termination" do
  describe "show?" do
    context "when change_type is job_termination" do
      it "returns true" do
        change_report = create(:change_report, :job_termination)

        show_form = subject.class.show?(change_report)
        expect(show_form).to eq(true)
      end
    end

    context "when change_type is new_job" do
      it "returns false" do
        change_report = create(:change_report, :new_job)

        show_form = subject.class.show?(change_report)
        expect(show_form).to eq(false)
      end
    end
  end
end
