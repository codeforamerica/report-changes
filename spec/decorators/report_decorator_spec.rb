require "rails_helper"

RSpec.describe ReportDecorator do
  describe "#ssn" do
    context "when there is a member with a ssn" do
      it "formats it" do
        report = build :report
        create :member, report: report, ssn: "333224444"

        decorator = ReportDecorator.new(report)

        expect(decorator.ssn).to eq "333-22-4444"
      end
    end

    context "when there is not a ssn" do
      it "returns nil" do
        report = build :report
        create :member, report: report, ssn: ""

        decorator = ReportDecorator.new(report)

        expect(decorator.ssn).to be_nil
      end
    end
  end

  describe "#birthday" do
    context "when there is a member with a birthday" do
      it "formats it" do
        birthday = DateTime.new(2018, 2, 3, 19, 5, 6)
        report = build :report
        create :member, report: report, birthday: birthday

        decorator = ReportDecorator.new(report)

        expect(decorator.birthday).to eq "02/03/18"
      end
    end

    context "when there is not a birthday" do
      it "returns nil" do
        report = build :report
        create :member, report: report, birthday: nil

        decorator = ReportDecorator.new(report)

        expect(decorator.birthday).to be_nil
      end
    end
  end

  describe "#client_name" do
    it "returns client full name" do
      report = build :report
      create :member, report: report, first_name: "Jane", last_name: "Doe"

      decorator = ReportDecorator.new(report)

      expect(decorator.client_name).to eq "Jane Doe"
    end
  end

  describe "#submitted_at" do
    context "when there is a submitted_at" do
      it "formats it and converts it to Mountain time" do
        submitted_at = DateTime.new(2018, 2, 3, 19, 5, 6)
        report = create :report, submitted_at: submitted_at

        decorator = ReportDecorator.new(report)

        expect(decorator.submitted_at).to eq "02/03/18, 12:05 PM"
      end
    end

    context "when there is not a submitted_at" do
      it "returns nil" do
        report = create :report, submitted_at: nil

        decorator = ReportDecorator.new(report)

        expect(decorator.submitted_at).to be_nil
      end
    end
  end

  describe "#client_phone_number" do
    context "when there is a phone_number" do
      it "formats it" do
        report = create :report, phone_number: "5553339999"

        decorator = ReportDecorator.new(report)

        expect(decorator.client_phone_number).to eq "555-333-9999"
      end
    end

    context "when there is not a phone_number" do
      it "returns nil" do
        report = create :report, phone_number: ""

        decorator = ReportDecorator.new(report)

        expect(decorator.client_phone_number).to be_nil
      end
    end
  end
end
