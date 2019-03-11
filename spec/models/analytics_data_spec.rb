require "rails_helper"

RSpec.describe AnalyticsData do
  describe "#to_h" do
    it "returns basic information" do
      report = create :report, :filled,
        created_at: DateTime.new(2018, 1, 2, 12, 0, 0),
        submitted_at: DateTime.new(2018, 1, 2, 12, 10, 0)

      report.current_member.update(
        birthday: 22.years.ago - 1.day,
      )

      create :change, change_type: :new_job, member: report.current_member

      create :change, change_type: :new_job, member: report.current_member

      report.metadata.update(
        consent_to_sms: "yes",
        feedback_rating: "positive",
        feedback_comments: "great!",
        what_county: "A different county.",
        email: nil,
      )

      report.navigator.update(
        county: "Arapahoe",
        zip_code: "80046",
        source: "Land of Ooo",
      )

      data = AnalyticsData.new(report).to_h

      expect(data.fetch(:age)).to eq(22)
      expect(data.fetch(:new_job_count)).to eq(2)
      expect(data.fetch(:job_termination_count)).to eq(1)
      expect(data.fetch(:change_in_hours_count)).to eq(0)
      expect(data.fetch(:consent_to_sms)).to eq("yes")
      expect(data.fetch(:county)).to eq("Arapahoe")
      expect(data.fetch(:feedback_rating)).to eq("positive")
      expect(data.fetch(:feedback_comments)).to eq("great!")
      expect(data.fetch(:source)).to eq("Land of Ooo")
      expect(data.fetch(:verification_documents_count)).to eq(0)
      expect(data.fetch(:submitted_at)).to eq(DateTime.new(2018, 1, 2, 12, 10, 0))
      expect(data.fetch(:time_to_complete)).to eq(10 * 60)
      expect(data.fetch(:want_a_copy)).to be_falsey
    end

    it "sends nil for any 'unfilled' values" do
      report = create :report, :filled
      report.metadata.update consent_to_sms: :unfilled

      data = AnalyticsData.new(report).to_h

      expect(data.fetch(:consent_to_sms)).to be_nil
    end

    context "when member and navigator and reported_change and change_navigator are not present" do
      it "does not error" do
        expect do
          AnalyticsData.new(build(:report)).to_h
        end.to_not raise_error
      end
    end

    context "before a client has submitted their report" do
      it "time_to_complete is nil" do
        report = create :report, submitted_at: nil

        data = AnalyticsData.new(report).to_h

        expect(data.fetch(:time_to_complete)).to be_nil
      end
    end
  end
end
