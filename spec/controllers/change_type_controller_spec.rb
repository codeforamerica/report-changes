require "rails_helper"

RSpec.describe ChangeTypeController do
  it_behaves_like "form controller base behavior"
  it_behaves_like "form controller successful update", {
    change_type: "job_termination",
  }
  it_behaves_like "form controller unsuccessful update"

  describe "show?" do
    context "when NEW_JOB_FLOW_ENABLED is true" do
      around do |example|
        with_modified_env NEW_JOB_FLOW_ENABLED: "true" do
          example.run
        end
      end

      it "returns true" do
        change_report = create(:change_report, :with_navigator)

        show_form = ChangeTypeController.show?(change_report)
        expect(show_form).to eq(true)
      end
    end

    context "when NEW_JOB_FLOW_ENABLED is false" do
      around do |example|
        with_modified_env NEW_JOB_FLOW_ENABLED: "false" do
          example.run
        end
      end

      it "returns false" do
        change_report = create(:change_report, :with_navigator)

        show_form = ChangeTypeController.show?(change_report)
        expect(show_form).to eq(false)
      end
    end
  end
end
