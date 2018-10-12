require "rails_helper"

RSpec.describe TellUsAboutTheNewJobForm do
  describe "validations" do
    let(:valid_params) do
      {
        company_name: "Abc Corp",
        manager_name: "Boss McBosserson",
        manager_phone_number: "111-222-3333",
        first_day_day: "15",
        first_day_month: "1",
        first_day_year: "2000",
        paid_yet: "yes",
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
        it "is invalid" do
          invalid_params = valid_params.merge(manager_name: nil)
          form = TellUsAboutTheNewJobForm.new(nil, invalid_params)

          expect(form).to_not be_valid
        end
      end
    end

    describe "manager_phone_number" do
      context "when the manager_phone_number is not included" do
        it "is invalid" do
          invalid_params = valid_params.merge(manager_phone_number: nil)
          form = TellUsAboutTheNewJobForm.new(nil, invalid_params)

          expect(form).to_not be_valid
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

    describe "first_day" do
      context "when the first_day is not included" do
        it "is invalid" do
          invalid_params = valid_params.merge(
            first_day_year: nil,
            first_day_month: nil,
            first_day_day: nil,
          )
          form = TellUsAboutTheNewJobForm.new(nil, invalid_params)

          expect(form).to_not be_valid
          expect(form.errors[:first_day].count).to eq 1
          expect(form.errors[:first_day].first).
            to eq "Please add a month, a day, and a year."
        end
      end

      context "when the first_day is not included" do
        it "is invalid" do
          invalid_params = valid_params.merge(
            first_day_year: 2000,
            first_day_month: 2,
            first_day_day: nil,
          )
          form = TellUsAboutTheNewJobForm.new(nil, invalid_params)

          expect(form).to_not be_valid
          expect(form.errors[:first_day].count).to eq 1
          expect(form.errors[:first_day].first).
            to eq "Please add a day."
          expect(form.first_day_year).to eq 2000
        end
      end

      context "when the first_day is not a valid date" do
        it "is invalid" do
          form = TellUsAboutTheNewJobForm.new(nil, first_day_year: 1992, first_day_month: 2, first_day_day: 30)

          expect(form).not_to be_valid
          expect(form.errors[:first_day].count).to eq 1
          expect(form.errors[:first_day].first).to eq "Please provide a real date."
        end
      end
    end

    describe "paid_yet" do
      context "when not answered" do
        it "is invalid" do
          form = TellUsAboutTheNewJobForm.new(nil, paid_yet: nil)

          expect(form).not_to be_valid
          expect(form.errors[:paid_yet].count).to eq 1
          expect(form.errors[:paid_yet].first).to eq "Please answer this question."
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
        first_day_day: "15",
        first_day_month: "1",
        first_day_year: "2000",
        paid_yet: "yes",
      }
    end

    it "persists the values to the correct models" do
      form = TellUsAboutTheNewJobForm.new(change_report, valid_params)
      form.valid?
      form.save

      change_report.reload

      expect(change_report.company_name).to eq "Abc Corp"
      expect(change_report.manager_name).to eq "Boss McBosser"
      expect(change_report.manager_phone_number).to eq "1112223333"
      expect(change_report.first_day.year).to eq 2000
      expect(change_report.first_day.month).to eq 1
      expect(change_report.first_day.day).to eq 15
      expect(change_report.paid_yet_yes?).to be_truthy
    end
  end

  describe ".from_change_report" do
    it "assigns values from change report and other objects" do
      change_report = create(:change_report,
        :with_navigator,
        company_name: "Abc Corp",
        manager_name: "Boss McBosser",
        manager_phone_number: "1112223333",
        first_day: DateTime.new(2000, 1, 15),
        paid_yet: "no")

      form = TellUsAboutTheNewJobForm.from_change_report(change_report)

      expect(form.company_name).to eq("Abc Corp")
      expect(form.manager_name).to eq("Boss McBosser")
      expect(form.manager_phone_number).to eq("1112223333")
      expect(form.first_day_year).to eq(2000)
      expect(form.first_day_month).to eq(1)
      expect(form.first_day_day).to eq(15)
      expect(form.paid_yet).to eq "no"
    end
  end
end
