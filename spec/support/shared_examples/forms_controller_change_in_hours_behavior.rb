require "rails_helper"

RSpec.shared_examples_for "form controller change in hours behavior" do
  it_behaves_like "form controller base behavior", "change_in_hours"

  describe "show?" do
    let(:report) { create :report, :filled }

    before do
      member = create :member, report: report
      change = create :change,
        change_type: change_type,
        member: member
      create :navigator,
        current_member: member,
        current_change: change,
        report: report
    end

    context "when change_type is change_in_hours" do
      let(:change_type) { "change_in_hours" }

      it "returns true" do
        show_form = subject.class.show?(report)
        expect(show_form).to eq(true)
      end
    end

    context "when change_type is new_job" do
      let(:change_type) { "new_job" }

      it "returns false" do
        show_form = subject.class.show?(report)
        expect(show_form).to eq(false)
      end
    end
  end
end
