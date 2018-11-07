require "rails_helper"

RSpec.describe WhatKindOfProofController do
  it_behaves_like "form controller base behavior"
  it_behaves_like "form controller successful update", {
    has_offer_letter: "yes",
    has_paystub: "no",
  }

  describe "show?" do
    context "when change_type is change_in_hours" do
      it "returns true" do
        change_report = create(:change_report, :change_in_hours)

        show_form = subject.class.show?(change_report)
        expect(show_form).to eq(true)
      end
    end

    context "when change_type is new_job" do
      it "returns true" do
        change_report = create(:change_report, :new_job)

        show_form = subject.class.show?(change_report)
        expect(show_form).to eq(true)
      end
    end

    context "when change_type is job_termination" do
      it "returns false" do
        change_report = create(:change_report, :job_termination)

        show_form = subject.class.show?(change_report)
        expect(show_form).to eq(false)
      end
    end
  end
end
