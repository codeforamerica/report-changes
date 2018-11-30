require "rails_helper"

RSpec.describe TellUsMoreAboutTheLostJobForm do
  describe "validations" do
    let(:valid_params) do
      {
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
        form = TellUsMoreAboutTheLostJobForm.new(nil, valid_params)

        expect(form).to be_valid
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
          form = TellUsMoreAboutTheLostJobForm.new(nil, invalid_params)

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
          form = TellUsMoreAboutTheLostJobForm.new(nil, invalid_params)

          expect(form).to_not be_valid
          expect(form.errors[:last_day].count).to eq 1
          expect(form.errors[:last_day].first).
            to eq "Please add a day."
          expect(form.last_day_year).to eq 2000
        end
      end

      context "when the last_day is not a valid date" do
        it "is invalid" do
          form = TellUsMoreAboutTheLostJobForm.new(nil, last_day_year: 1992, last_day_month: 2, last_day_day: 30)

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
          form = TellUsMoreAboutTheLostJobForm.new(nil, invalid_params)

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
          form = TellUsMoreAboutTheLostJobForm.new(nil, invalid_params)

          expect(form).to_not be_valid
          expect(form.errors[:last_paycheck].count).to eq 1
          expect(form.errors[:last_paycheck].first).to eq "Please add a day."
          expect(form.last_paycheck_year).to eq 2000
        end
      end

      context "when the last_paycheck is not a valid date" do
        it "is invalid" do
          form = TellUsMoreAboutTheLostJobForm.new(nil,
                                               last_paycheck_year: 1992,
                                               last_paycheck_month: 2,
                                               last_paycheck_day: 30)

          expect(form).not_to be_valid
          expect(form.errors[:last_paycheck].count).to eq 1
          expect(form.errors[:last_paycheck].first).to eq "Please provide a real date."
        end
      end
    end

    describe "last_paycheck_amount" do
      context "when the last_paycheck_amount is nil" do
        it "is valid" do
          params = valid_params.merge(
            last_paycheck_amount: nil,
          )
          form = TellUsMoreAboutTheLostJobForm.new(nil, params)

          expect(form).to be_valid
          expect(form.last_paycheck_amount).to be_nil
        end
      end

      context "when the last_paycheck_amount is blank" do
        it "is valid" do
          params = valid_params.merge(
            last_paycheck_amount: "",
          )
          form = TellUsMoreAboutTheLostJobForm.new(nil, params)

          expect(form).to be_valid
          expect(form.last_paycheck_amount).to eq ""
        end
      end

      context "when the last_paycheck_amount is included and is a money shaped decimal" do
        it "is valid" do
          params = valid_params.merge(
            last_paycheck_amount: "127.14",
          )
          form = TellUsMoreAboutTheLostJobForm.new(nil, params)

          expect(form).to be_valid
          expect(form.last_paycheck_amount).to eq "127.14"
        end
      end

      context "when the last_paycheck_amount is included and contains non-numeric (or , or .) characters" do
        it "is valid" do
          params = valid_params.merge(
            last_paycheck_amount: "abc",
          )
          form = TellUsMoreAboutTheLostJobForm.new(nil, params)

          expect(form).not_to be_valid
          expect(form.errors[:last_paycheck_amount].count).to eq 1
          expect(form.errors[:last_paycheck_amount].first).to eq "Please add a number."
        end
      end

      context "when the last_paycheck_amount is too long" do
        it "is valid" do
          params = valid_params.merge(
            last_paycheck_amount: "100,000",
          )
          form = TellUsMoreAboutTheLostJobForm.new(nil, params)

          expect(form).not_to be_valid
          expect(form.errors[:last_paycheck_amount].count).to eq 1
          expect(form.errors[:last_paycheck_amount].first).to eq "Please add a number."
        end
      end
    end
  end

  describe "#save" do
    let(:report) { create :report }
    let(:valid_params) do
      {
        last_day_day: "15",
        last_day_month: "1",
        last_day_year: "2000",
        last_paycheck_day: "28",
        last_paycheck_month: "2",
        last_paycheck_year: "2018",
        last_paycheck_amount: "1,127.143",
      }
    end

    context "when the member does not yet exist" do
      it "persists the values to the correct models" do
        form = TellUsMoreAboutTheLostJobForm.new(report, valid_params)
        form.valid?
        form.save

        report.reload

        expect(report.last_day.year).to eq 2000
        expect(report.last_day.month).to eq 1
        expect(report.last_day.day).to eq 15
        expect(report.last_paycheck.year).to eq 2018
        expect(report.last_paycheck.month).to eq 2
        expect(report.last_paycheck.day).to eq 28
        expect(report.last_paycheck_amount).to eq 1127.14
      end
    end
  end

  describe ".from_report" do
    it "assigns values from change report and other objects" do
      report = create(:report,
                             :with_navigator,
                             last_day: DateTime.new(2000, 1, 15),
                             last_paycheck: DateTime.new(2018, 2, 28),
                             last_paycheck_amount: 1127.14)

      form = TellUsMoreAboutTheLostJobForm.from_report(report)

      expect(form.last_day_year).to eq(2000)
      expect(form.last_day_month).to eq(1)
      expect(form.last_day_day).to eq(15)
      expect(form.last_paycheck_year).to eq(2018)
      expect(form.last_paycheck_month).to eq(2)
      expect(form.last_paycheck_day).to eq(28)
      expect(form.last_paycheck_amount).to eq(1127.14)
    end
  end
end
