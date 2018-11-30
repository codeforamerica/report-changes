require "rails_helper"

RSpec.describe TellUsMoreAboutTheNewJobForm do
  describe "validations" do
    let(:valid_params) do
      {
        first_day_day: "15",
        first_day_month: "1",
        first_day_year: "2000",
        paid_yet: "yes",
      }
    end

    context "when all required attributes provided" do
      it "is valid" do
        form = TellUsMoreAboutTheNewJobForm.new(nil, valid_params)

        expect(form).to be_valid
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
          form = TellUsMoreAboutTheNewJobForm.new(nil, invalid_params)

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
          form = TellUsMoreAboutTheNewJobForm.new(nil, invalid_params)

          expect(form).to_not be_valid
          expect(form.errors[:first_day].count).to eq 1
          expect(form.errors[:first_day].first).
            to eq "Please add a day."
          expect(form.first_day_year).to eq 2000
        end
      end

      context "when the first_day is not a valid date" do
        it "is invalid" do
          form = TellUsMoreAboutTheNewJobForm.new(nil, first_day_year: 1992, first_day_month: 2, first_day_day: 30)

          expect(form).not_to be_valid
          expect(form.errors[:first_day].count).to eq 1
          expect(form.errors[:first_day].first).to eq "Please provide a real date."
        end
      end
    end

    describe "paid_yet" do
      context "when not answered" do
        it "is invalid" do
          form = TellUsMoreAboutTheNewJobForm.new(nil, paid_yet: nil)

          expect(form).not_to be_valid
          expect(form.errors[:paid_yet].count).to eq 1
          expect(form.errors[:paid_yet].first).to eq "Please answer this question."
        end
      end
    end
  end

  describe "#save" do
    let(:report) { create :report }
    let(:valid_params) do
      {
        first_day_day: "15",
        first_day_month: "1",
        first_day_year: "2000",
        paid_yet: "yes",
      }
    end

    it "persists the values to the correct models" do
      form = TellUsMoreAboutTheNewJobForm.new(report, valid_params)
      form.valid?
      form.save

      report.reload

      expect(report.first_day.year).to eq 2000
      expect(report.first_day.month).to eq 1
      expect(report.first_day.day).to eq 15
      expect(report.paid_yet_yes?).to be_truthy
    end
  end

  describe ".from_report" do
    it "assigns values from change report and other objects" do
      report = create(:report,
        :with_navigator,
        first_day: DateTime.new(2000, 1, 15),
        paid_yet: "no")

      form = TellUsMoreAboutTheNewJobForm.from_report(report)

      expect(form.first_day_year).to eq(2000)
      expect(form.first_day_month).to eq(1)
      expect(form.first_day_day).to eq(15)
      expect(form.paid_yet).to eq "no"
    end
  end
end
