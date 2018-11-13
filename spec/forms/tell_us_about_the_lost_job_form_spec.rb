require "rails_helper"

RSpec.describe TellUsAboutTheLostJobForm do
  describe "validations" do
    let(:valid_params) do
      {
        company_name: "Abc Corp",
      }
    end

    context "when all required attributes provided" do
      it "is valid" do
        form = TellUsAboutTheLostJobForm.new(nil, valid_params)

        expect(form).to be_valid
      end
    end

    describe "company_name" do
      context "when the company_name is not included" do
        it "is invalid" do
          invalid_params = valid_params.merge(company_name: nil)
          form = TellUsAboutTheLostJobForm.new(nil, invalid_params)

          expect(form).to_not be_valid
        end
      end
    end

    describe "manager_phone_number" do
      context "when correctly formatted manager_phone_number is included" do
        it "is valid" do
          invalid_params = valid_params.merge(manager_phone_number: "111-111-1234")
          form = TellUsAboutTheLostJobForm.new(nil, invalid_params)

          expect(form).to be_valid
        end
      end

      context "when the manager_phone_number is a blank string" do
        it "is valid" do
          form = TellUsAboutTheLostJobForm.new(nil, valid_params.merge(manager_phone_number: ""))

          expect(form).to be_valid
        end
      end

      context "when the manager_phone_number has less than 10 digits" do
        it "is invalid" do
          invalid_params = valid_params.merge(manager_phone_number: "111-111-123")
          form = TellUsAboutTheLostJobForm.new(nil, invalid_params)

          expect(form).to_not be_valid
        end
      end
    end
  end

  describe "#save" do
    let(:change_report) { create :change_report }
    let(:valid_params) do
      {
        company_name: "Abc Corp",
        manager_name: "Boss McBosser",
        manager_phone_number: "111-222-3333",
        manager_additional_information: "They're my boss",
      }
    end

    context "when the member does not yet exist" do
      it "persists the values to the correct models" do
        form = TellUsAboutTheLostJobForm.new(change_report, valid_params)
        form.valid?
        form.save

        change_report.reload

        expect(change_report.company_name).to eq "Abc Corp"
        expect(change_report.manager_name).to eq "Boss McBosser"
        expect(change_report.manager_phone_number).to eq "1112223333"
        expect(change_report.manager_additional_information).to eq "They're my boss"
      end
    end
  end

  describe ".from_change_report" do
    it "assigns values from change report and other objects" do
      change_report = create(:change_report,
        :with_navigator,
        company_name: "Abc Corp",
        manager_name: "Boss McBosser",
        manager_phone_number: "1112223333",
        manager_additional_information: "They're my boss")

      form = TellUsAboutTheLostJobForm.from_change_report(change_report)

      expect(form.company_name).to eq("Abc Corp")
      expect(form.manager_name).to eq("Boss McBosser")
      expect(form.manager_phone_number).to eq("1112223333")
      expect(form.manager_additional_information).to eq("They're my boss")
    end
  end
end
