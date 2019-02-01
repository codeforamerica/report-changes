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
    let(:report) { create :report, :with_change }
    let(:valid_params) do
      {
        company_name: "Abc Corp",
        manager_name: "Boss McBosser",
        manager_phone_number: "111-222-3333",
        manager_additional_information: "They're my boss",
      }
    end

    it "persists the values to the correct models" do
      form = TellUsAboutTheLostJobForm.new(report, valid_params)
      form.valid?
      form.save

      report.current_change.reload

      expect(report.current_change.company_name).to eq "Abc Corp"
      expect(report.current_change.manager_name).to eq "Boss McBosser"
      expect(report.current_change.manager_phone_number).to eq "1112223333"
      expect(report.current_change.manager_additional_information).to eq "They're my boss"
    end
  end

  describe ".from_report" do
    it "assigns values from change report and other objects" do
      report = create(:report,
        :with_navigator,
        reported_changes: [build(:change,
        company_name: "Abc Corp",
        manager_name: "Boss McBosser",
        manager_phone_number: "1112223333",
        manager_additional_information: "They're my boss")])

      form = TellUsAboutTheLostJobForm.from_report(report)

      expect(form.company_name).to eq("Abc Corp")
      expect(form.manager_name).to eq("Boss McBosser")
      expect(form.manager_phone_number).to eq("1112223333")
      expect(form.manager_additional_information).to eq("They're my boss")
    end
  end
end
