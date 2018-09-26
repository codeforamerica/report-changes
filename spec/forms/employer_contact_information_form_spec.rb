require "rails_helper"

RSpec.describe EmployerContactInformationForm do
  describe "validations" do
    let(:valid_params) do
      {
        manager_name: "best attribute",
        manager_phone_number: "555-555-5555",
      }
    end

    context "when manager_name and manager_phone_number is provided" do
      it "is valid" do
        form = EmployerContactInformationForm.new(nil, valid_params)

        expect(form).to be_valid
      end
    end

    context "when manager_name is not provided" do
      it "is invalid" do
        invalid_params = valid_params.merge(manager_name: nil)
        form = EmployerContactInformationForm.new(nil, invalid_params)

        expect(form).not_to be_valid
        expect(form.errors[:manager_name]).to be_present
      end
    end

    context "when manager_phone_number is not provided" do
      it "is invalid" do
        invalid_params = valid_params.merge(manager_phone_number: nil)
        form = EmployerContactInformationForm.new(nil, invalid_params)

        expect(form).not_to be_valid
        expect(form.errors[:manager_phone_number]).to be_present
      end
    end

    context "when manager_phone_number is too short" do
      it "is invalid" do
        invalid_params = valid_params.merge(manager_phone_number: "5551234")
        form = EmployerContactInformationForm.new(nil, invalid_params)

        expect(form).not_to be_valid
        expect(form.errors[:manager_phone_number]).to be_present
      end
    end
  end

  describe "#save" do
    let(:change_report) { create :change_report }

    let(:valid_params) do
      {
        manager_name: "Jane Doe",
        manager_phone_number: "555-555-5555",
        manager_additional_information: "No.",
      }
    end

    it "persists the values to the correct models" do
      form = EmployerContactInformationForm.new(change_report, valid_params)
      form.valid?
      form.save

      change_report.reload

      expect(change_report.manager_name).to eq "Jane Doe"
      expect(change_report.manager_phone_number).to eq "5555555555"
      expect(change_report.manager_additional_information).to eq "No."
    end
  end
end
