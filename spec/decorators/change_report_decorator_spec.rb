require "rails_helper"

RSpec.describe ChangeReportDecorator do
  describe "#formatted_company_phone_number" do
    context "when there is a company_phone_number" do
      it "formats it" do
        change_report = create :change_report, company_phone_number: "5553339999"
        decorator = ChangeReportDecorator.new(change_report)
        expect(decorator.formatted_company_phone_number).to eq "(555) 333-9999"
      end
    end

    context "when there is not a company_phone_number" do
      it "returns nil" do
        change_report = create :change_report, company_phone_number: nil
        decorator = ChangeReportDecorator.new(change_report)
        expect(decorator.formatted_company_phone_number).to be_nil
      end
    end
  end

  describe "#formatted_ssn" do
    context "when there is a member with a ssn" do
      it "formats it" do
        change_report = build :change_report
        create :household_member, change_report: change_report, ssn: "333224444"
        decorator = ChangeReportDecorator.new(change_report)
        expect(decorator.formatted_ssn).to eq "333-22-4444"
      end
    end

    context "when there is not a ssn" do
      it "returns nil" do
        change_report = build :change_report
        create :household_member, change_report: change_report, ssn: nil
        decorator = ChangeReportDecorator.new(change_report)
        expect(decorator.formatted_ssn).to be_nil
      end
    end

    context "when there is not a member" do
      it "returns nil" do
        change_report = create :change_report
        decorator = ChangeReportDecorator.new(change_report)
        expect(decorator.formatted_ssn).to be_nil
      end
    end
  end

  describe "#formatted_birthday" do
    context "when there is a member with a birthday" do
      it "formats it" do
        birthday = DateTime.new(2018, 2, 3, 19, 5, 6)
        change_report = build :change_report
        create :household_member, change_report: change_report, birthday: birthday
        decorator = ChangeReportDecorator.new(change_report)
        expect(decorator.formatted_birthday).to eq "02/03/18"
      end
    end

    context "when there is not a ssn" do
      it "returns nil" do
        change_report = build :change_report
        create :household_member, change_report: change_report, birthday: nil
        decorator = ChangeReportDecorator.new(change_report)
        expect(decorator.formatted_birthday).to be_nil
      end
    end

    context "when there is not a member" do
      it "returns nil" do
        change_report = create :change_report
        decorator = ChangeReportDecorator.new(change_report)
        expect(decorator.formatted_birthday).to be_nil
      end
    end
  end

  describe "#member_name" do
    context "when there is a member" do
      it "returns it" do
        change_report = build :change_report
        create :household_member, change_report: change_report, name: "Jane"
        decorator = ChangeReportDecorator.new(change_report)
        expect(decorator.member_name).to eq "Jane"
      end
    end

    context "when there is not a member" do
      it "returns nil" do
        change_report = create :change_report
        decorator = ChangeReportDecorator.new(change_report)
        expect(decorator.member_name).to be_nil
      end
    end
  end

  describe "#formatted_submitted_at" do
    context "when there is a submitted_at" do
      it "formats it and converts it to Mountain time" do
        submitted_at = DateTime.new(2018, 2, 3, 19, 5, 6)
        change_report = create :change_report, submitted_at: submitted_at
        decorator = ChangeReportDecorator.new(change_report)
        expect(decorator.formatted_submitted_at).to eq "02/03/18, 12:05 PM"
      end
    end

    context "when there is not a submitted_at" do
      it "returns nil" do
        change_report = create :change_report, submitted_at: nil
        decorator = ChangeReportDecorator.new(change_report)
        expect(decorator.formatted_submitted_at).to be_nil
      end
    end
  end

  describe "#formatted_last_day" do
    context "when there is a last_day" do
      it "formats it" do
        last_day = DateTime.new(2018, 2, 3, 19, 5, 6)
        change_report = create :change_report, last_day: last_day
        decorator = ChangeReportDecorator.new(change_report)
        expect(decorator.formatted_last_day).to eq "02/03/18"
      end
    end

    context "when there is not a last_day" do
      it "returns nil" do
        change_report = create :change_report, last_day: nil
        decorator = ChangeReportDecorator.new(change_report)
        expect(decorator.formatted_last_day).to be_nil
      end
    end
  end

  describe "#formatted_last_paycheck" do
    context "when there is a last_paycheck" do
      it "formats it" do
        last_paycheck = DateTime.new(2018, 2, 3, 19, 5, 6)
        change_report = create :change_report, last_paycheck: last_paycheck
        decorator = ChangeReportDecorator.new(change_report)
        expect(decorator.formatted_last_paycheck).to eq "02/03/18"
      end
    end

    context "when there is not a last_day" do
      it "returns nil" do
        change_report = create :change_report, last_paycheck: nil
        decorator = ChangeReportDecorator.new(change_report)
        expect(decorator.formatted_last_paycheck).to be_nil
      end
    end
  end
end
