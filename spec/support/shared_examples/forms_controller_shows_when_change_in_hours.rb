require "rails_helper"

RSpec.shared_examples_for "form controller shows when change in hours" do
  describe "show?" do
    context "when change_type is change_in_hours" do
      it "returns true" do
        change_report = create(:change_report, :change_in_hours)

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
