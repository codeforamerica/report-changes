require "rails_helper"

RSpec.describe AnalyticsData do
  describe "#to_h" do
    it "returns basic information" do
      navigator = build(:navigator,
                                  county_from_address: "Littleland",
                                  has_new_job_documents: "yes",
                                  has_job_termination_documents: "yes",
                                  selected_county_location: "arapahoe",
                                  is_self_employed: "no",
                                  source: "Land of Ooo")

      member = build(:member, birthday: (22.years.ago - 1.week))

      metadata = build(:report_metadata,
                                 consent_to_sms: "yes",
                                 feedback_rating: "positive")

      report = create(:report,
        navigator: navigator,
        member: member,
        metadata: metadata,
        submitted_at: DateTime.new(2018, 1, 2),
        new_job_change: build(:change,
          change_type: "new_job",
          paid_how_often: "monthly",
          paid_yet: "no",
          first_day: DateTime.new(2016, 1, 2),
          report: report),
        job_termination_change: build(:change,
          change_type: "job_termination",
          last_paycheck: DateTime.new(2017, 1, 2),
          last_day: DateTime.new(2016, 1, 2),
          report: report))

      data = AnalyticsData.new(report).to_h

      expect(data.fetch(:age)).to eq(22)
      expect(data.fetch(:new_job)).to eq("yes")
      expect(data.fetch(:job_termination)).to eq("yes")
      expect(data.fetch(:change_in_hours)).to eq("no")
      expect(data.fetch(:consent_to_sms)).to eq("yes")
      expect(data.fetch(:county_from_address)).to eq("Littleland")
      expect(data.fetch(:feedback_rating)).to eq("positive")
      expect(data.fetch(:has_new_job_documents)).to eq("yes")
      expect(data.fetch(:has_job_termination_documents)).to eq("yes")
      expect(data.fetch(:is_self_employed)).to eq("no")
      expect(data.fetch(:paid_how_often)).to eq("monthly")
      expect(data.fetch(:paid_yet)).to eq("no")
      expect(data.fetch(:selected_county_location)).to eq("arapahoe")
      expect(data.fetch(:source)).to eq("Land of Ooo")
      expect(data.fetch(:verification_documents_count)).to eq(0)
      expect(data.fetch(:submitted_at)).to eq(DateTime.new(2018, 1, 2))
    end

    it "calculates time since submission" do
      submission_date = Time.utc(2018, 1, 10, 1, 2, 3)
      report = build(:report, submitted_at: submission_date)
      create(:change,
        change_type: "new_job",
        first_day: submission_date - 30.days,
        first_paycheck: submission_date - 20.days,
        same_hours: "yes",
        report: report)
      create(:change,
        change_type: "job_termination",
        last_day: submission_date - 90.days,
        last_paycheck: submission_date - 100.days,
        report: report)
      data = AnalyticsData.new(report).to_h

      expect(data.fetch(:same_hours)).to eq("yes")
      expect(data.fetch(:days_since_first_day_to_submission)).to eq(30)
      expect(data.fetch(:days_since_first_paycheck_to_submission)).to eq(20)
      expect(data.fetch(:days_since_last_day_to_submission)).to eq(90)
      expect(data.fetch(:days_since_last_paycheck_to_submission)).to eq(100)
    end

    it "sends nil for any 'unfilled' values" do
      change = build(:change,
                    same_hours: "unfilled",
                    report: build(:report))
      data = AnalyticsData.new(change.report).to_h

      expect(data.fetch(:same_hours)).to be_nil
    end

    context "when member and navigator and_reported_change are not present" do
      it "does not error" do
        expect do
          AnalyticsData.new(build(:report)).to_h
        end.to_not raise_error
      end
    end
  end
end
