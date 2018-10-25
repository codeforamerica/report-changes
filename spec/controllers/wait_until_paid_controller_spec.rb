require "rails_helper"

RSpec.describe WaitUntilPaidController do
  it_behaves_like "form controller base behavior"
  it_behaves_like "form controller shows when new job"

  describe "show?" do
    context "when reporting new job" do
      context "when client has not been paid yet" do
        it "returns true" do
          change_report = create(:change_report, :new_job, paid_yet: "no")

          show_form = WaitUntilPaidController.show?(change_report)
          expect(show_form).to eq(true)
        end
      end

      context "when client has been paid already" do
        it "returns false" do
          change_report = create(:change_report, :new_job, paid_yet: "yes")

          show_form = WaitUntilPaidController.show?(change_report)
          expect(show_form).to eq(false)
        end
      end
    end
  end
end
