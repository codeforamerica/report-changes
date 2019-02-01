require "rails_helper"

RSpec.describe HowMuchWillYouMakeForm do
  describe "validations" do
    let(:valid_params) do
      {
        hourly_wage: "9.50",
        same_hours: "yes",
        same_hours_a_week_amount: "25",
        lower_hours_a_week_amount: nil,
        upper_hours_a_week_amount: nil,
        paid_how_often: "Every two weeks",
        first_paycheck_day: "15",
        first_paycheck_month: "1",
        first_paycheck_year: "2018",
        new_job_notes: "Those extra hours were only for one week",
      }
    end

    context "when all required attributes provided" do
      it "is valid" do
        form = HowMuchWillYouMakeForm.new(nil, valid_params)

        expect(form).to be_valid
      end
    end

    describe "hourly_wage" do
      context "when the hourly_wage is not included" do
        it "is invalid" do
          invalid_params = valid_params.merge(hourly_wage: nil)
          form = HowMuchWillYouMakeForm.new(nil, invalid_params)

          expect(form).to_not be_valid
        end
      end
    end

    describe "same_hours" do
      context "when the same_hours is not included" do
        it "is invalid" do
          invalid_params = valid_params.merge(same_hours: nil)
          form = HowMuchWillYouMakeForm.new(nil, invalid_params)

          expect(form).to_not be_valid
        end
      end

      context "when same_hours is yes" do
        context "and same hours a week amount is nil" do
          it "is invalid" do
            invalid_params = valid_params.merge(same_hours: "yes", same_hours_a_week_amount: nil)
            form = HowMuchWillYouMakeForm.new(nil, invalid_params)

            expect(form).to_not be_valid
            expect(form.errors[:same_hours_a_week_amount]).to be_present
          end
        end
      end

      context "when same_hours is no" do
        context "and both lower and upper hours a week amount are provided" do
          it "is valid" do
            valid_params.merge!(same_hours: "no",
                                lower_hours_a_week_amount: "30",
                                upper_hours_a_week_amount: "40")
            form = HowMuchWillYouMakeForm.new(nil, valid_params)

            expect(form).to be_valid
          end
        end

        context "and lower hours a week amount is nil" do
          it "is invalid" do
            invalid_params = valid_params.merge(same_hours: "no",
                                                lower_hours_a_week_amount: nil,
                                                upper_hours_a_week_amount: "40")
            form = HowMuchWillYouMakeForm.new(nil, invalid_params)

            expect(form).to_not be_valid
            expect(form.errors[:lower_hours_a_week_amount]).to be_present
          end
        end

        context "and upper hours a week amount is nil" do
          it "is invalid" do
            invalid_params = valid_params.merge(same_hours: "no",
                                                lower_hours_a_week_amount: "40",
                                                upper_hours_a_week_amount: nil)
            form = HowMuchWillYouMakeForm.new(nil, invalid_params)

            expect(form).to_not be_valid
            expect(form.errors[:upper_hours_a_week_amount]).to be_present
          end
        end
      end
    end

    describe "paid_how_often" do
      context "when the paid_how_often is not included" do
        it "is invalid" do
          invalid_params = valid_params.merge(paid_how_often: nil)
          form = HowMuchWillYouMakeForm.new(nil, invalid_params)

          expect(form).to_not be_valid
        end
      end
    end

    describe "first_paycheck" do
      context "when the first_paycheck is not included" do
        it "is invalid" do
          invalid_params = valid_params.merge(
            first_paycheck_year: nil,
            first_paycheck_month: nil,
            first_paycheck_day: nil,
          )
          form = HowMuchWillYouMakeForm.new(nil, invalid_params)

          expect(form).to_not be_valid
          expect(form.errors[:first_paycheck].count).to eq 1
          expect(form.errors[:first_paycheck].first).
            to eq "Please add a month, a day, and a year."
        end
      end

      context "when the first_paycheck is not included" do
        it "is invalid" do
          invalid_params = valid_params.merge(
            first_paycheck_year: 2000,
            first_paycheck_month: 2,
            first_paycheck_day: nil,
          )
          form = HowMuchWillYouMakeForm.new(nil, invalid_params)

          expect(form).to_not be_valid
          expect(form.errors[:first_paycheck].count).to eq 1
          expect(form.errors[:first_paycheck].first).
            to eq "Please add a day."
          expect(form.first_paycheck_year).to eq 2000
        end
      end

      context "when the first_paycheck is not a valid date" do
        it "is invalid" do
          date_args = { first_paycheck_year: 1992, first_paycheck_month: 2, first_paycheck_day: 30 }
          form = HowMuchWillYouMakeForm.new(nil, date_args)

          expect(form).not_to be_valid
          expect(form.errors[:first_paycheck].count).to eq 1
          expect(form.errors[:first_paycheck].first).to eq "Please provide a real date."
        end
      end
    end
  end

  describe "#save" do
    let(:report) { create :report, :with_change, change_type: :new_job }
    let(:valid_params) do
      {
        hourly_wage: "9.50",
        same_hours: "no",
        same_hours_a_week_amount: nil,
        lower_hours_a_week_amount: "5",
        upper_hours_a_week_amount: "25",
        paid_how_often: "Every two weeks",
        first_paycheck_day: "15",
        first_paycheck_month: "1",
        first_paycheck_year: "2018",
        new_job_notes: "Those extra hours were only for one week",
      }
    end

    it "persists the values to the correct models" do
      form = HowMuchWillYouMakeForm.new(report, valid_params)
      form.valid?
      form.save

      report.reload

      expect(report.current_change.hourly_wage).to eq "9.50"
      expect(report.current_change.same_hours).to eq "no"
      expect(report.current_change.same_hours_a_week_amount).to eq nil
      expect(report.current_change.lower_hours_a_week_amount).to eq "5"
      expect(report.current_change.upper_hours_a_week_amount).to eq "25"
      expect(report.current_change.paid_how_often).to eq "Every two weeks"
      expect(report.current_change.first_paycheck.year).to eq 2018
      expect(report.current_change.first_paycheck.month).to eq 1
      expect(report.current_change.first_paycheck.day).to eq 15
      expect(report.current_change.new_job_notes).to eq "Those extra hours were only for one week"
    end

    context "when same_hours is no" do
      it "saves hourly range and does not save same hours amount" do
        valid_params.merge!(same_hours: "no",
                            same_hours_a_week_amount: "50",
                            lower_hours_a_week_amount: "5",
                            upper_hours_a_week_amount: "25")
        form = HowMuchWillYouMakeForm.new(report, valid_params)
        form.valid?
        form.save

        report.reload

        expect(report.current_change.same_hours).to eq "no"
        expect(report.current_change.same_hours_a_week_amount).to eq nil
        expect(report.current_change.lower_hours_a_week_amount).to eq "5"
        expect(report.current_change.upper_hours_a_week_amount).to eq "25"
      end
    end

    context "when same_hours is yes" do
      it "does not save varying hours amounts" do
        valid_params.merge!(same_hours: "yes",
                            same_hours_a_week_amount: "50",
                            lower_hours_a_week_amount: "5",
                            upper_hours_a_week_amount: "25")
        form = HowMuchWillYouMakeForm.new(report, valid_params)
        form.valid?
        form.save

        report.reload

        expect(report.current_change.same_hours).to eq "yes"
        expect(report.current_change.same_hours_a_week_amount).to eq "50"
        expect(report.current_change.lower_hours_a_week_amount).to eq nil
        expect(report.current_change.upper_hours_a_week_amount).to eq nil
      end
    end
  end

  describe ".from_report" do
    it "assigns values from change report and other objects" do
      report = create(:report)
      create(:change,
             change_type: "new_job",
             hourly_wage: "9.50",
             same_hours: "yes",
             same_hours_a_week_amount: "50",
             paid_how_often: "Every two weeks",
             first_paycheck: DateTime.new(2018, 1, 15),
             new_job_notes: "Those extra hours were only for one week",
             report: report)

      form = HowMuchWillYouMakeForm.from_report(report)

      expect(form.hourly_wage).to eq "9.50"
      expect(form.same_hours).to eq "yes"
      expect(form.same_hours_a_week_amount).to eq "50"
      expect(form.lower_hours_a_week_amount).to eq nil
      expect(form.upper_hours_a_week_amount).to eq nil
      expect(form.paid_how_often).to eq "Every two weeks"
      expect(form.first_paycheck_year).to eq 2018
      expect(form.first_paycheck_month).to eq 1
      expect(form.first_paycheck_day).to eq 15
      expect(form.new_job_notes).to eq "Those extra hours were only for one week"
    end
  end
end
