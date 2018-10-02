require "rails_helper"

RSpec.describe TellUsAboutTheJobForm do
  describe "validations" do
    let(:valid_params) do
      {
        company_name: "Abc Corp",
        manager_name: "Boss McBosserson",
        manager_phone_number: "111-222-3333",
        last_day_day: "15",
        last_day_month: "1",
        last_day_year: "2000",
        last_paycheck_day: "28",
        last_paycheck_month: "2",
        last_paycheck_year: "2018",
      }
    end

    context "when all required attributes provided" do
      it "is valid" do
        form = TellUsAboutTheJobForm.new(nil, valid_params)

        expect(form).to be_valid
      end
    end

    describe "company_name" do
      context "when the company_name is not included" do
        it "is invalid" do
          invalid_params = valid_params.merge(company_name: nil)
          form = TellUsAboutTheJobForm.new(nil, invalid_params)

          expect(form).to_not be_valid
        end
      end
    end

    describe "manager_name" do
      context "when the manager_name is not included" do
        it "is invalid" do
          invalid_params = valid_params.merge(manager_name: nil)
          form = TellUsAboutTheJobForm.new(nil, invalid_params)

          expect(form).to_not be_valid
        end
      end
    end

    describe "manager_phone_number" do
      context "when the manager_phone_number is not included" do
        it "is invalid" do
          invalid_params = valid_params.merge(manager_phone_number: nil)
          form = TellUsAboutTheJobForm.new(nil, invalid_params)

          expect(form).to_not be_valid
        end
      end

      context "when the manager_phone_number has less than 10 digits" do
        it "is invalid" do
          invalid_params = valid_params.merge(manager_phone_number: "111-111-111")
          form = TellUsAboutTheJobForm.new(nil, invalid_params)

          expect(form).to_not be_valid
        end
      end
    end

    describe "last_day" do
      context "when the last_day is not included" do
        it "is invalid" do
          invalid_params = valid_params.merge(
            last_day_year: nil,
            last_day_month: nil,
            last_day_day: nil,
          )
          form = TellUsAboutTheJobForm.new(nil, invalid_params)

          expect(form).to_not be_valid
          expect(form.errors[:last_day].count).to eq 1
          expect(form.errors[:last_day].first).
            to eq "Please add a month, a day, and a year."
        end
      end

      context "when the last_day is not included" do
        it "is invalid" do
          invalid_params = valid_params.merge(
            last_day_year: 2000,
            last_day_month: 2,
            last_day_day: nil,
          )
          form = TellUsAboutTheJobForm.new(nil, invalid_params)

          expect(form).to_not be_valid
          expect(form.errors[:last_day].count).to eq 1
          expect(form.errors[:last_day].first).
            to eq "Please add a day."
          expect(form.last_day_year).to eq 2000
        end
      end

      context "when the last_day is not a valid date" do
        it "is invalid" do
          form = TellUsAboutTheJobForm.new(nil, last_day_year: 1992, last_day_month: 2, last_day_day: 30)

          expect(form).not_to be_valid
          expect(form.errors[:last_day].count).to eq 1
          expect(form.errors[:last_day].first).to eq "Please provide a real date."
        end
      end
    end

    describe "last_paycheck" do
      context "when the last_paycheck is not included" do
        it "is invalid" do
          invalid_params = valid_params.merge(
            last_paycheck_year: nil,
            last_paycheck_month: nil,
            last_paycheck_day: nil,
          )
          form = TellUsAboutTheJobForm.new(nil, invalid_params)

          expect(form).to_not be_valid
          expect(form.errors[:last_paycheck].count).to eq 1
          expect(form.errors[:last_paycheck].first).
            to eq "Please add a month, a day, and a year."
        end
      end

      context "when the last_paycheck is not included" do
        it "is invalid" do
          invalid_params = valid_params.merge(
            last_paycheck_year: 2000,
            last_paycheck_month: 2,
            last_paycheck_day: nil,
          )
          form = TellUsAboutTheJobForm.new(nil, invalid_params)

          expect(form).to_not be_valid
          expect(form.errors[:last_paycheck].count).to eq 1
          expect(form.errors[:last_paycheck].first).to eq "Please add a day."
          expect(form.last_paycheck_year).to eq 2000
        end
      end

      context "when the last_paycheck is not a valid date" do
        it "is invalid" do
          form = TellUsAboutTheJobForm.new(nil,
            last_paycheck_year: 1992,
            last_paycheck_month: 2,
            last_paycheck_day: 30)

          expect(form).not_to be_valid
          expect(form.errors[:last_paycheck].count).to eq 1
          expect(form.errors[:last_paycheck].first).to eq "Please provide a real date."
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
        last_day_day: "15",
        last_day_month: "1",
        last_day_year: "2000",
        last_paycheck_day: "28",
        last_paycheck_month: "2",
        last_paycheck_year: "2018",
      }
    end

    context "when the member does not yet exist" do
      it "persists the values to the correct models" do
        form = TellUsAboutTheJobForm.new(change_report, valid_params)
        form.valid?
        form.save

        change_report.reload

        expect(change_report.company_name).to eq "Abc Corp"
        expect(change_report.manager_name).to eq "Boss McBosser"
        expect(change_report.manager_phone_number).to eq "1112223333"
        expect(change_report.last_day.year).to eq 2000
        expect(change_report.last_day.month).to eq 1
        expect(change_report.last_day.day).to eq 15
        expect(change_report.last_paycheck.year).to eq 2018
        expect(change_report.last_paycheck.month).to eq 2
        expect(change_report.last_paycheck.day).to eq 28
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
        last_day: DateTime.new(2000, 1, 15),
        last_paycheck: DateTime.new(2018, 2, 28))

      form = TellUsAboutTheJobForm.from_change_report(change_report)

      expect(form.company_name).to eq("Abc Corp")
      expect(form.manager_name).to eq("Boss McBosser")
      expect(form.manager_phone_number).to eq("1112223333")
      expect(form.last_day_year).to eq(2000)
      expect(form.last_day_month).to eq(1)
      expect(form.last_day_day).to eq(15)
      expect(form.last_paycheck_year).to eq(2018)
      expect(form.last_paycheck_month).to eq(2)
      expect(form.last_paycheck_day).to eq(28)
    end
  end
end
