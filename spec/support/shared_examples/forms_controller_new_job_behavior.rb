require "rails_helper"

RSpec.shared_examples_for "form controller new job behavior" do
  it_behaves_like "form controller base behavior", "new_job"

  describe "show?" do
    context "when change_type is new job" do
      it "returns true" do
        report = create :report
        member = create :member, report: report
        change = create :change, member: member, change_type: "new_job"
        create :navigator, current_member: member, current_change: change, report: report

        show_form = subject.class.show?(report)
        expect(show_form).to eq(true)
      end
    end

    context "when change_type is not new_job" do
      it "returns false" do
        report = create :report
        member = create :member, report: report
        change = create :change, member: member, change_type: "job_termination"
        create :navigator, current_member: member, current_change: change, report: report

        show_form = subject.class.show?(report)
        expect(show_form).to eq(false)
      end
    end
  end
end
