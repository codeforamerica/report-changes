require "rails_helper"

RSpec.describe ChangeReportDecorator do
  describe "#manager_phone_number" do
    context "when there is a manager_phone_number" do
      it "formats it" do
        change_report = create :change_report, manager_phone_number: "5553339999"
        decorator = ChangeReportDecorator.new(change_report)
        expect(decorator.manager_phone_number).to eq "555-333-9999"
      end
    end

    context "when there is not a manager_phone_number" do
      it "returns nil" do
        change_report = create :change_report, manager_phone_number: nil
        decorator = ChangeReportDecorator.new(change_report)
        expect(decorator.manager_phone_number).to be_nil
      end
    end
  end

  describe "#ssn" do
    context "when there is a member with a ssn" do
      it "formats it" do
        change_report = build :change_report
        create :household_member, change_report: change_report, ssn: "333224444"
        decorator = ChangeReportDecorator.new(change_report)
        expect(decorator.ssn).to eq "333-22-4444"
      end
    end

    context "when there is not a ssn" do
      it "returns 'no response'" do
        change_report = build :change_report
        create :household_member, change_report: change_report, ssn: ""
        decorator = ChangeReportDecorator.new(change_report)
        expect(decorator.ssn).to eq "no response"
      end
    end

    context "when there is not a member" do
      it "returns 'no response'" do
        change_report = create :change_report
        decorator = ChangeReportDecorator.new(change_report)
        expect(decorator.ssn).to eq "no response"
      end
    end
  end

  describe "#birthday" do
    context "when there is a member with a birthday" do
      it "formats it" do
        birthday = DateTime.new(2018, 2, 3, 19, 5, 6)
        change_report = build :change_report
        create :household_member, change_report: change_report, birthday: birthday
        decorator = ChangeReportDecorator.new(change_report)
        expect(decorator.birthday).to eq "02/03/18"
      end
    end

    context "when there is not a ssn" do
      it "returns nil" do
        change_report = build :change_report
        create :household_member, change_report: change_report, birthday: nil
        decorator = ChangeReportDecorator.new(change_report)
        expect(decorator.birthday).to be_nil
      end
    end

    context "when there is not a member" do
      it "returns nil" do
        change_report = create :change_report
        decorator = ChangeReportDecorator.new(change_report)
        expect(decorator.birthday).to be_nil
      end
    end
  end

  describe "#client_name" do
    context "when there is a member" do
      it "returns it" do
        change_report = build :change_report
        create :household_member, change_report: change_report, name: "Jane"
        decorator = ChangeReportDecorator.new(change_report)
        expect(decorator.client_name).to eq "Jane"
      end
    end

    context "when there is not a member" do
      it "returns nil" do
        change_report = create :change_report
        decorator = ChangeReportDecorator.new(change_report)
        expect(decorator.client_name).to be_nil
      end
    end
  end

  describe "#submitted_at" do
    context "when there is a submitted_at" do
      it "formats it and converts it to Mountain time" do
        submitted_at = DateTime.new(2018, 2, 3, 19, 5, 6)
        change_report = create :change_report, submitted_at: submitted_at
        decorator = ChangeReportDecorator.new(change_report)
        expect(decorator.submitted_at).to eq "02/03/18, 12:05 PM"
      end
    end

    context "when there is not a submitted_at" do
      it "returns nil" do
        change_report = create :change_report, submitted_at: nil
        decorator = ChangeReportDecorator.new(change_report)
        expect(decorator.submitted_at).to be_nil
      end
    end
  end

  describe "#last_day" do
    context "when there is a last_day" do
      it "formats it" do
        last_day = DateTime.new(2018, 2, 3, 19, 5, 6)
        change_report = create :change_report, last_day: last_day
        decorator = ChangeReportDecorator.new(change_report)
        expect(decorator.last_day).to eq "02/03/18"
      end
    end

    context "when there is not a last_day" do
      it "returns nil" do
        change_report = create :change_report, last_day: nil
        decorator = ChangeReportDecorator.new(change_report)
        expect(decorator.last_day).to be_nil
      end
    end
  end

  describe "#last_paycheck" do
    context "when there is a last_paycheck" do
      it "formats it" do
        last_paycheck = DateTime.new(2018, 2, 3, 19, 5, 6)
        change_report = create :change_report, last_paycheck: last_paycheck
        decorator = ChangeReportDecorator.new(change_report)
        expect(decorator.last_paycheck).to eq "02/03/18"
      end
    end

    context "when there is not a last_day" do
      it "returns nil" do
        change_report = create :change_report, last_paycheck: nil
        decorator = ChangeReportDecorator.new(change_report)
        expect(decorator.last_paycheck).to be_nil
      end
    end
  end

  describe "#case_number" do
    context "when there is a case number" do
      it "returns it" do
        change_report = create :change_report, case_number: "123abc"
        decorator = ChangeReportDecorator.new(change_report)
        expect(decorator.case_number).to eq "123abc"
      end
    end

    context "when there is no case number" do
      it "returns 'no response'" do
        change_report = create :change_report, case_number: nil
        decorator = ChangeReportDecorator.new(change_report)
        expect(decorator.case_number).to eq "no response"
      end
    end

    context "when there is no case number" do
      it "returns 'no response'" do
        change_report = create :change_report, case_number: ""
        decorator = ChangeReportDecorator.new(change_report)
        expect(decorator.case_number).to eq "no response"
      end
    end
  end

  describe "#client_phone_number" do
    context "when there is a phone_number" do
      it "formats it" do
        change_report = create :change_report, phone_number: "5553339999"
        decorator = ChangeReportDecorator.new(change_report)
        expect(decorator.client_phone_number).to eq "555-333-9999"
      end
    end

    context "when there is not a phone_number" do
      it "returns nil" do
        change_report = create :change_report, phone_number: nil
        decorator = ChangeReportDecorator.new(change_report)
        expect(decorator.client_phone_number).to be_nil
      end
    end
  end

  describe "#uploaded_proof" do
    context "when the client uploaded a verification document" do
      it "returns 'yes'" do
        change_report = create :change_report, :with_letter
        decorator = ChangeReportDecorator.new(change_report)
        expect(decorator.uploaded_proof).to eq "yes"
      end
    end

    context "when the client did not upload a verification document" do
      it "returns 'no'" do
        change_report = create :change_report
        decorator = ChangeReportDecorator.new(change_report)
        expect(decorator.uploaded_proof).to eq "no"
      end
    end
  end

  describe "#termination_letter" do
    context "when the client has one" do
      it "returns See attached" do
        navigator = build :change_report_navigator, has_letter: "yes"
        change_report = create :change_report, navigator: navigator
        decorator = ChangeReportDecorator.new(change_report)
        expect(decorator.termination_letter).to eq "See attached"
      end
    end

    context "when the client does not have one" do
      it "returns Client does not have this" do
        navigator = build :change_report_navigator, has_letter: "no"
        change_report = create :change_report, navigator: navigator
        decorator = ChangeReportDecorator.new(change_report)
        expect(decorator.termination_letter).to eq "Client does not have this"
      end
    end
  end

  describe "#last_paycheck_amount" do
    context "when there is not an amount" do
      it "returns no response" do
        change_report = create :change_report, last_paycheck_amount: nil
        decorator = ChangeReportDecorator.new(change_report)
        expect(decorator.last_paycheck_amount).to eq "no response"
      end
    end

    context "when there is an amount" do
      it "returns the formatted amount" do
        change_report = create :change_report, last_paycheck_amount: 1127.14
        decorator = ChangeReportDecorator.new(change_report)
        expect(decorator.last_paycheck_amount).to eq "$1,127.14"
      end
    end
  end
end
