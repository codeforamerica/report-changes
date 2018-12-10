require "rails_helper"

RSpec.describe TellUsAboutTheNewJobForm do
  describe "validations" do
    let(:valid_params) do
      {
        company_name: "Abc Corp",
        manager_name: "Boss McBosserson",
        manager_phone_number: "111-222-3333",
      }
    end

    context "when all required attributes provided" do
      it "is valid" do
        form = TellUsAboutTheNewJobForm.new(nil, valid_params)

        expect(form).to be_valid
      end
    end

    describe "company_name" do
      context "when the company_name is not included" do
        it "is invalid" do
          invalid_params = valid_params.merge(company_name: nil)
          form = TellUsAboutTheNewJobForm.new(nil, invalid_params)

          expect(form).to_not be_valid
        end
      end
    end

    describe "manager_name" do
      context "when the manager_name is not included" do
        it "is valid" do
          form = TellUsAboutTheNewJobForm.new(nil, valid_params.merge(manager_name: nil))

          expect(form).to be_valid
        end
      end
    end

    describe "manager_phone_number" do
      context "when the manager_phone_number is a blank string" do
        it "is valid" do
          params = valid_params.merge(manager_phone_number: "")
          form = TellUsAboutTheNewJobForm.new(nil, params)
          expect(form).to be_valid
        end
      end

      context "when the manager_phone_number has less than 10 digits" do
        it "is invalid" do
          invalid_params = valid_params.merge(manager_phone_number: "111-111-111")
          form = TellUsAboutTheNewJobForm.new(nil, invalid_params)

          expect(form).to_not be_valid
        end
      end
    end
  end

  describe "#save" do
    let(:report) { create :report, :with_change, change_type: :new_job }
    let(:valid_params) do
      {
        company_name: "Abc Corp",
        manager_name: "Boss McBosser",
        manager_phone_number: "111-222-3333",
      }
    end

    it "persists the values to the correct models" do
      form = TellUsAboutTheNewJobForm.new(report, valid_params)
      form.valid?
      form.save

      report.reload

      expect(report.new_job_change.company_name).to eq "Abc Corp"
      expect(report.new_job_change.manager_name).to eq "Boss McBosser"
      expect(report.new_job_change.manager_phone_number).to eq "1112223333"
    end
  end

  describe ".from_report" do
    it "assigns values from change report and other objects" do
      change = build(:change,
                     company_name: "Abc Corp",
                     manager_name: "Boss McBosser",
                     manager_phone_number: "1112223333")
      report = create(:report, :with_navigator, new_job_change: change)
      form = TellUsAboutTheNewJobForm.from_report(report)
      expect(form.company_name).to eq("Abc Corp")
      expect(form.manager_name).to eq("Boss McBosser")
      expect(form.manager_phone_number).to eq("1112223333")
    end
  end
end
