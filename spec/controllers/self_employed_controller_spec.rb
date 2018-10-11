require "rails_helper"

RSpec.describe SelfEmployedController do
  it_behaves_like "form controller base behavior"
  it_behaves_like "form controller successful update", {
    is_self_employed: "no",
  }
  it_behaves_like "form controller unsuccessful update"

  describe "show?" do
    context "when change_type is new job" do
      it "returns true" do
        change_report = create(:change_report, change_type: "new_job")

        show_form = subject.class.show?(change_report)
        expect(show_form).to eq(true)
      end
    end

    context "when change_type is not new_job" do
      it "returns false" do
        change_report = create(:change_report, change_type: "job_termination")

        show_form = subject.class.show?(change_report)
        expect(show_form).to eq(false)
      end
    end
  end
end
