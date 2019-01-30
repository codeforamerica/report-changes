require "rails_helper"

RSpec.describe TellUsAboutChangeInHoursJobForm do
  let(:valid_params) do
    {
      company_name: "Abc Corp",
      manager_name: "Boss McBosserson",
      manager_phone_number: "111-222-3333",
    }
  end

  describe "validations" do
    context "when all required attributes provided" do
      it "is valid" do
        form = TellUsAboutChangeInHoursJobForm.new(nil, valid_params)

        expect(form).to be_valid
      end
    end

    describe "company_name" do
      context "when the company_name is not included" do
        it "is invalid" do
          invalid_params = valid_params.merge(company_name: nil)
          form = TellUsAboutChangeInHoursJobForm.new(nil, invalid_params)

          expect(form).to_not be_valid
        end
      end
    end

    describe "manager_name" do
      context "when the manager_name is not included" do
        it "is valid" do
          form = TellUsAboutChangeInHoursJobForm.new(nil, valid_params.merge(manager_name: nil))

          expect(form).to be_valid
        end
      end
    end

    describe "manager_phone_number" do
      context "when the manager_phone_number is not included" do
        it "is valid" do
          form = TellUsAboutChangeInHoursJobForm.new(nil, valid_params.merge(manager_phone_number: nil))

          expect(form).to be_valid
        end
      end

      context "when the manager_phone_number is an empty string" do
        it "is valid" do
          form = TellUsAboutChangeInHoursJobForm.new(nil, valid_params.merge(manager_phone_number: ""))

          expect(form).to be_valid
        end
      end

      context "when the manager_phone_number has less than 10 digits" do
        it "is invalid" do
          invalid_params = valid_params.merge(manager_phone_number: "111-111-111")
          form = TellUsAboutChangeInHoursJobForm.new(nil, invalid_params)

          expect(form).to_not be_valid
        end
      end
    end
  end

  describe "#save" do
    let(:report) { create :report, :with_change, change_type: :change_in_hours }

    it "persists the values to the correct models" do
      form = TellUsAboutChangeInHoursJobForm.new(report, valid_params)
      form.valid?
      form.save

      report.reload

      expect(report.reported_changes.last.company_name).to eq("Abc Corp")
      expect(report.reported_changes.last.manager_name).to eq("Boss McBosserson")
      expect(report.reported_changes.last.manager_phone_number).to eq("1112223333")
    end
  end

  describe ".from_report" do
    it "assigns values from change report" do
      report = create :report, :with_navigator
      create :change, report: report,
                      company_name: "Abc Corp",
                      manager_name: "Boss McBosserson",
                      manager_phone_number: "1112223333"

      form = TellUsAboutChangeInHoursJobForm.from_report(report)

      expect(form.company_name).to eq("Abc Corp")
      expect(form.manager_name).to eq("Boss McBosserson")
      expect(form.manager_phone_number).to eq("1112223333")
    end
  end
end
