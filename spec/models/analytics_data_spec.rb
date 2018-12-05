require "rails_helper"

RSpec.describe AnalyticsData do
  let(:mock_change) do
    instance_double(Change,
    first_day: nil,
    first_paycheck: nil,
    last_day: nil,
    last_paycheck: nil).as_null_object
  end
  let(:mock_report) do
    instance_double(Report,
      submitted_at: nil,
      reported_change: mock_change,
      letters: []).as_null_object
  end

  describe "#to_h" do
    it "returns basic information" do
      navigator = instance_double(Navigator,
                                  county_from_address: "Littleland",
                                  has_documents: "yes",
                                  selected_county_location: "arapahoe",
                                  is_self_employed: "no",
                                  source: "Land of Ooo")

      member = instance_double(Member, age: 22)

      metadata = instance_double(ReportMetadata,
                                 consent_to_sms: "yes",
                                 feedback_rating: "positive")

      allow(mock_report).to receive_messages(
        navigator: navigator,
        member: member,
        metadata: metadata,
        submitted_at: DateTime.new(2018, 1, 2),
      )
      allow(mock_change).to receive_messages(
        change_type: "new_job",
        paid_how_often: "monthly",
        paid_yet: "no",
      )

      data = AnalyticsData.new(mock_report).to_h

      expect(data.fetch(:age)).to eq(22)
      expect(data.fetch(:change_type)).to eq("new_job")
      expect(data.fetch(:consent_to_sms)).to eq("yes")
      expect(data.fetch(:county_from_address)).to eq("Littleland")
      expect(data.fetch(:feedback_rating)).to eq("positive")
      expect(data.fetch(:has_documents)).to eq("yes")
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
      allow(mock_report).to receive_messages(submitted_at: submission_date)
      allow(mock_change).to receive_messages(
        change_type: "new_job",
        first_day: submission_date - 30.days,
        first_paycheck: submission_date - 20.days,
        last_day: submission_date - 90.days,
        last_paycheck: submission_date - 100.days,
        same_hours: "yes",
      )
      data = AnalyticsData.new(mock_report).to_h

      expect(data.fetch(:same_hours)).to eq("yes")
      expect(data.fetch(:days_since_first_day_to_submission)).to eq(30)
      expect(data.fetch(:days_since_first_paycheck_to_submission)).to eq(20)
      expect(data.fetch(:days_since_last_day_to_submission)).to eq(90)
      expect(data.fetch(:days_since_last_paycheck_to_submission)).to eq(100)
    end

    it "sends nil for any 'unfilled' values" do
      allow(mock_change).to receive_messages(same_hours: "unfilled")

      data = AnalyticsData.new(mock_report).to_h

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
