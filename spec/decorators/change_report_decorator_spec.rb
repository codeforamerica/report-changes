require "rails_helper"

RSpec.describe ChangeReportDecorator do
  describe "#manager_name" do
    context "when there is a manager_name" do
      it "returns the name" do
        change_report = create :change_report, manager_name: "Frances Perkins"
        decorator = ChangeReportDecorator.new(change_report)
        expect(decorator.manager_name).to eq "Frances Perkins"
      end
    end

    context "when there is not a manager_name" do
      it "returns no response" do
        change_report = create :change_report, manager_name: nil
        decorator = ChangeReportDecorator.new(change_report)
        expect(decorator.manager_name).to eq "no response"
      end
    end
  end

  describe "#manager_phone_number" do
    context "when there is a manager_phone_number" do
      it "formats it" do
        change_report = create :change_report, manager_phone_number: "5553339999"
        decorator = ChangeReportDecorator.new(change_report)
        expect(decorator.manager_phone_number).to eq "555-333-9999"
      end
    end

    context "when there is not a manager_phone_number" do
      it "returns no response" do
        change_report = create :change_report, manager_phone_number: nil
        decorator = ChangeReportDecorator.new(change_report)
        expect(decorator.manager_phone_number).to eq "no response"
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
      it "returns client full name" do
        change_report = build :change_report
        create :household_member, change_report: change_report, first_name: "Jane", last_name: "Doe"
        decorator = ChangeReportDecorator.new(change_report)
        expect(decorator.client_name).to eq "Jane Doe"
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

    context "when there is not a last_paycheck" do
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

  describe "#termination_verification" do
    context "when the client has one" do
      it "returns See attached" do
        navigator = build :change_report_navigator, has_termination_letter: "yes"
        change_report = create :change_report, navigator: navigator
        decorator = ChangeReportDecorator.new(change_report)
        expect(decorator.termination_verification).to eq "See attached"
      end
    end

    context "when the client does not have one" do
      it "returns Client does not have this" do
        navigator = build :change_report_navigator, has_termination_letter: "no"
        change_report = create :change_report, navigator: navigator
        decorator = ChangeReportDecorator.new(change_report)
        expect(decorator.termination_verification).to eq "Client does not have this"
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

  describe "#first_day" do
    context "when there is a first_day" do
      it "formats it" do
        first_day = DateTime.new(2018, 2, 3, 19, 5, 6)
        change_report = create :change_report, first_day: first_day
        decorator = ChangeReportDecorator.new(change_report)
        expect(decorator.first_day).to eq "02/03/18"
      end
    end

    context "when there is not a first_day" do
      it "returns nil" do
        change_report = create :change_report, first_day: nil
        decorator = ChangeReportDecorator.new(change_report)
        expect(decorator.first_day).to be_nil
      end
    end
  end

  describe "#first_paycheck" do
    context "when there is a first_paycheck" do
      it "formats it" do
        first_paycheck = DateTime.new(2018, 2, 3, 19, 5, 6)
        change_report = create :change_report, first_paycheck: first_paycheck
        decorator = ChangeReportDecorator.new(change_report)
        expect(decorator.first_paycheck).to eq "02/03/18"
      end
    end

    context "when there is not a first_paycheck" do
      it "returns nil" do
        change_report = create :change_report, first_paycheck: nil
        decorator = ChangeReportDecorator.new(change_report)
        expect(decorator.first_paycheck).to be_nil
      end
    end
  end

  describe "#hourly_wage" do
    context "when there is an hourly_wage" do
      it "formats it" do
        change_report = create :change_report, hourly_wage: "50"
        decorator = ChangeReportDecorator.new(change_report)
        expect(decorator.hourly_wage).to eq "$50 /hr"
      end
    end

    context "when there is not an hourly_wage" do
      it "returns nil" do
        change_report = create :change_report, hourly_wage: nil
        decorator = ChangeReportDecorator.new(change_report)
        expect(decorator.hourly_wage).to be_nil
      end
    end
  end

  describe "#hours_a_week" do
    context "when the hours are the same" do
      it "returns the value" do
        change_report = create :change_report, same_hours: "yes",
                                               same_hours_a_week_amount: "20"
        decorator = ChangeReportDecorator.new(change_report)
        expect(decorator.hours_a_week).to eq "20"
      end
    end

    context "when the hours are in a range" do
      it "returns the range" do
        change_report = create :change_report, same_hours: "no",
                                               lower_hours_a_week_amount: "5",
                                               upper_hours_a_week_amount: "15"
        decorator = ChangeReportDecorator.new(change_report)
        expect(decorator.hours_a_week).to eq "5-15"
      end
    end

    context "when there are no hours" do
      it "returns nil" do
        change_report = create :change_report, same_hours: "unfilled"
        decorator = ChangeReportDecorator.new(change_report)
        expect(decorator.hours_a_week).to be_nil
      end
    end
  end

  describe "#change_in_hours_hours_a_week" do
    context "when only the lower hours are present" do
      it "returns the value" do
        change_report = create :change_report, lower_hours_a_week_amount: "5"
        decorator = ChangeReportDecorator.new(change_report)
        expect(decorator.change_in_hours_hours_a_week).to eq "5"
      end
    end

    context "when both the lower and upper hours are present" do
      it "returns the range" do
        change_report = create :change_report, lower_hours_a_week_amount: "5", upper_hours_a_week_amount: "15"
        decorator = ChangeReportDecorator.new(change_report)
        expect(decorator.change_in_hours_hours_a_week).to eq "5-15"
      end
    end
  end

  describe "#uploaded_new_job_verification" do
    context "when the client uploaded documents" do
      it "returns 'Yes'" do
        change_report = create :change_report, :with_letter
        decorator = ChangeReportDecorator.new(change_report)
        expect(decorator.uploaded_new_job_verification).to eq "Yes"
      end
    end

    context "when the client did not upload documents" do
      it "returns 'Neither'" do
        change_report = create :change_report
        decorator = ChangeReportDecorator.new(change_report)
        expect(decorator.uploaded_new_job_verification).to eq "Neither"
      end
    end
  end

  describe "#change_date" do
    context "when there is a change_date" do
      it "formats it" do
        change_date = DateTime.new(2018, 2, 3, 19, 5, 6)
        change_report = create :change_report, change_date: change_date
        decorator = ChangeReportDecorator.new(change_report)
        expect(decorator.change_date).to eq "02/03/18"
      end
    end

    context "when there is not a change_date" do
      it "returns nil" do
        change_report = create :change_report, change_date: nil
        decorator = ChangeReportDecorator.new(change_report)
        expect(decorator.change_date).to be_nil
      end
    end
  end

  describe "#change_type_description" do
    context "when it is a job termination" do
      it "returns the job termination string" do
        change_report = create :change_report, change_type: :job_termination
        decorator = ChangeReportDecorator.new(change_report)
        expect(decorator.change_type_description).to eq "Income change: job termination"
      end
    end

    context "when it is a new job" do
      it "returns the new job string" do
        change_report = create :change_report, change_type: :new_job
        decorator = ChangeReportDecorator.new(change_report)
        expect(decorator.change_type_description).to eq "Income change: new job"
      end
    end

    context "when it is a change in hours" do
      it "returns the change in hours string" do
        change_report = create :change_report, change_type: :change_in_hours
        decorator = ChangeReportDecorator.new(change_report)
        expect(decorator.change_type_description).to eq "Income change: change in hours"
      end
    end
  end

  describe "#paid_yet" do
    context "new job change type" do
      it "returns the paid_yet value" do
        change_report = create :change_report, change_type: :new_job, paid_yet: "yes"
        decorator = ChangeReportDecorator.new(change_report)
        expect(decorator.paid_yet).to eq "yes"
      end
    end

    context "job termination change type" do
      it "returns empty string" do
        change_report = create :change_report, change_type: :job_termination, paid_yet: "unfilled"
        decorator = ChangeReportDecorator.new(change_report)
        expect(decorator.paid_yet).to eq ""
      end
    end

    context "new job change type" do
      it "returns empty string" do
        change_report = create :change_report, change_type: :change_in_hours, paid_yet: "unfilled"
        decorator = ChangeReportDecorator.new(change_report)
        expect(decorator.paid_yet).to eq ""
      end
    end
  end

  describe "#same_hours" do
    context "new job change type" do
      it "returns the same_hours value" do
        change_report = create :change_report, change_type: :new_job, same_hours: "yes"
        decorator = ChangeReportDecorator.new(change_report)
        expect(decorator.same_hours).to eq "yes"
      end
    end

    context "job termination change type" do
      it "returns empty string" do
        change_report = create :change_report, change_type: :job_termination, same_hours: "unfilled"
        decorator = ChangeReportDecorator.new(change_report)
        expect(decorator.same_hours).to eq ""
      end
    end

    context "new job change type" do
      it "returns empty string" do
        change_report = create :change_report, change_type: :change_in_hours, same_hours: "unfilled"
        decorator = ChangeReportDecorator.new(change_report)
        expect(decorator.same_hours).to eq ""
      end
    end
  end
end
