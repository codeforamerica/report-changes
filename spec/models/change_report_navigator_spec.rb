require "rails_helper"

RSpec.describe ChangeReportNavigator do
  describe ".supported_county?" do
    let(:change_report) { build(:change_report) }

    context "with selected county location of arapahoe" do
      it "returns true" do
        navigator = build(:change_report_navigator,
                           selected_county_location: :arapahoe,
                           change_report: change_report)

        expect(navigator.supported_county?).to be_truthy
      end
    end

    context "with county from address of Arapahoe County" do
      it "returns true" do
        navigator = build(:change_report_navigator,
                           county_from_address: "Arapahoe County",
                           change_report: change_report)

        expect(navigator.supported_county?).to be_truthy
      end
    end

    context "with neither selected county location nor county from address matching arapahoe" do
      it "returns false" do
        navigator = build(:change_report_navigator,
                           selected_county_location: :not_sure,
                           county_from_address: "Jefferson County",
                           change_report: change_report)

        expect(navigator.supported_county?).to be_falsey
      end
    end
  end

  describe "#documents_to_upload" do
    let(:change_report) { create :change_report }

    context "when paystubs selected" do
      it "returns :paystub" do
        change_report.create_navigator has_paystub: "yes"

        expect(change_report.navigator.documents_to_upload).to eq :paystub
      end
    end
    context "when offer letter and paystubs selected" do
      it "returns :offer_letter_and_paystub" do
        change_report.create_navigator has_offer_letter: "yes", has_paystub: "yes"

        expect(change_report.navigator.documents_to_upload).to eq :offer_letter_and_paystub
      end
    end
    context "when offer letter selected" do
      it "returns :offer_letter" do
        change_report.create_navigator has_offer_letter: "yes"

        expect(change_report.navigator.documents_to_upload).to eq :offer_letter
      end
    end
    context "when termination letter selected" do
      it "returns :termination_letter" do
        change_report.create_navigator has_termination_letter: "yes"

        expect(change_report.navigator.documents_to_upload).to eq :termination_letter
      end
    end
    context "when change in hours letter selected" do
      it "returns :change_in_hours_letter" do
        change_report.create_navigator has_change_in_hours_letter: "yes"

        expect(change_report.navigator.documents_to_upload).to eq :change_in_hours_letter
      end
    end
    context "when change in hours letter and paystubs selected" do
      it "returns :change_in_hours_letter_and_paystub" do
        change_report.create_navigator has_paystub: "yes", has_change_in_hours_letter: "yes"

        expect(change_report.navigator.documents_to_upload).to eq :change_in_hours_letter_and_paystub
      end
    end
  end
end
