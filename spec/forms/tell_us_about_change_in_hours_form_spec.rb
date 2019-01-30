require "rails_helper"

RSpec.describe TellUsAboutChangeInHoursForm do
  let(:valid_params) do
    {
      hourly_wage: "9.50",
      lower_hours_a_week_amount: "20",
      upper_hours_a_week_amount: nil,
      paid_how_often: "Every two weeks",
      change_date_day: "15",
      change_date_month: "1",
      change_date_year: "2018",
      change_in_hours_notes: "Those extra hours were only for one week",
    }
  end

  describe "validations" do
    context "when all required attributes provided" do
      it "is valid" do
        form = TellUsAboutChangeInHoursForm.new(nil, valid_params)

        expect(form).to be_valid
      end
    end

    describe "hourly_wage" do
      context "when the hourly_wage is not included" do
        it "is invalid" do
          invalid_params = valid_params.merge(hourly_wage: nil)
          form = TellUsAboutChangeInHoursForm.new(nil, invalid_params)

          expect(form).to_not be_valid
          expect(form.errors[:hourly_wage]).to be_present
        end
      end
    end

    describe "hourly range" do
      context "and both lower and upper hours a week amount are provided" do
        it "is valid" do
          valid_params.merge!(lower_hours_a_week_amount: "30",
                              upper_hours_a_week_amount: "40")
          form = TellUsAboutChangeInHoursForm.new(nil, valid_params)

          expect(form).to be_valid
        end
      end

      context "and lower hours a week amount is nil" do
        it "is invalid" do
          invalid_params = valid_params.merge(lower_hours_a_week_amount: nil,
                                              upper_hours_a_week_amount: "40")
          form = TellUsAboutChangeInHoursForm.new(nil, invalid_params)

          expect(form).to_not be_valid
          expect(form.errors[:lower_hours_a_week_amount]).to be_present
        end
      end

      context "and upper hours a week amount is nil" do
        it "is valid" do
          invalid_params = valid_params.merge(lower_hours_a_week_amount: "40",
                                              upper_hours_a_week_amount: nil)
          form = TellUsAboutChangeInHoursForm.new(nil, invalid_params)

          expect(form).to be_valid
        end
      end
    end

    describe "paid_how_often" do
      context "when the paid_how_often is not included" do
        it "is invalid" do
          invalid_params = valid_params.merge(paid_how_often: nil)
          form = TellUsAboutChangeInHoursForm.new(nil, invalid_params)

          expect(form).to_not be_valid
          expect(form.errors[:paid_how_often]).to be_present
        end
      end
    end

    describe "change date" do
      context "when no date is provided" do
        it "is invalid" do
          invalid_params = valid_params.merge(change_date_month: nil, change_date_day: nil, change_date_year: nil)
          form = TellUsAboutChangeInHoursForm.new(nil, invalid_params)

          expect(form).to_not be_valid
          expect(form.errors[:change_date]).to be_present
        end
      end

      context "when partial date is provided" do
        it "is invalid" do
          invalid_params = valid_params.merge(change_date_year: nil)
          form = TellUsAboutChangeInHoursForm.new(nil, invalid_params)

          expect(form).to_not be_valid
          expect(form.errors[:change_date]).to be_present
        end
      end
    end
  end

  describe "#save" do
    let(:report) { create :report, :with_change, change_type: :change_in_hours }

    it "persists the values to the correct models" do
      form = TellUsAboutChangeInHoursForm.new(report, valid_params)
      form.valid?
      form.save

      report.reload

      expect(report.reported_changes.last.hourly_wage).to eq("9.50")
      expect(report.reported_changes.last.lower_hours_a_week_amount).to eq("20")
      expect(report.reported_changes.last.upper_hours_a_week_amount).to be_nil
      expect(report.reported_changes.last.paid_how_often).to eq("Every two weeks")
      expect(report.reported_changes.last.change_date).to eq(DateTime.new(2018, 1, 15))
      expect(report.reported_changes.last.change_in_hours_notes).to eq("Those extra hours were only for one week")
    end
  end

  describe ".from_report" do
    it "assigns values from change report" do
      report = create :report
      create :change, report: report,
                      hourly_wage: "9.50",
                      lower_hours_a_week_amount: "20",
                      upper_hours_a_week_amount: "25",
                      paid_how_often: "Every two weeks",
                      change_date: DateTime.new(2018, 1, 15),
                      change_in_hours_notes: "Those extra hours were only for one week"

      form = TellUsAboutChangeInHoursForm.from_report(report)

      expect(form.hourly_wage).to eq("9.50")
      expect(form.lower_hours_a_week_amount).to eq("20")
      expect(form.upper_hours_a_week_amount).to eq("25")
      expect(form.paid_how_often).to eq("Every two weeks")
      expect(form.change_date_day).to eq(15)
      expect(form.change_date_month).to eq(1)
      expect(form.change_date_year).to eq(2018)
      expect(form.change_in_hours_notes).to eq("Those extra hours were only for one week")
    end
  end
end
