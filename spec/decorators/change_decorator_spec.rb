require "rails_helper"

RSpec.describe ChangeDecorator do
  let(:report) { create :report, :filled }
  let(:member) { create :member, report: report }

  describe "#manager_phone_number" do
    context "when there is a manager_phone_number" do
      it "formats it" do
        change = create :change,
          manager_phone_number: "5553339999",
          member: member

        decorator = described_class.new(change)

        expect(decorator.manager_phone_number).to eq "555-333-9999"
      end
    end

    context "when there is not a manager_phone_number" do
      it "returns nil" do
        change = create :change,
          manager_phone_number: nil,
          member: member

        decorator = described_class.new(change)

        expect(decorator.manager_phone_number).to be_nil
      end
    end
  end

  describe "#first_day" do
    context "when there is a first_day" do
      it "formats it" do
        change = create :change, first_day: DateTime.new(2018, 2, 3, 19, 5, 6),
                                 member: member

        decorator = described_class.new(change)

        expect(decorator.first_day).to eq "02/03/18"
      end
    end

    context "when there is not a first_day" do
      it "returns nil" do
        change = create :change, first_day: nil,
                                 member: member

        decorator = described_class.new(change)

        expect(decorator.first_day).to be_nil
      end
    end
  end

  describe "#last_day" do
    context "when there is a last_day" do
      it "formats it" do
        change = create :change, last_day: DateTime.new(2018, 2, 3, 19, 5, 6),
                                 member: member

        decorator = described_class.new(change)

        expect(decorator.last_day).to eq "02/03/18"
      end
    end

    context "when there is not a last_day" do
      it "returns nil" do
        change = create :change, last_day: nil,
                                 member: member

        decorator = described_class.new(change)

        expect(decorator.last_day).to be_nil
      end
    end
  end

  describe "#first_paycheck" do
    context "when there is a first_paycheck" do
      it "formats it" do
        change = create :change, first_paycheck: DateTime.new(2018, 2, 3, 19, 5, 6),
                                 member: member

        decorator = described_class.new(change)

        expect(decorator.first_paycheck).to eq "02/03/18"
      end
    end

    context "when there is not a first_paycheck" do
      it "returns nil" do
        change = create :change, first_paycheck: nil,
                                 member: member

        decorator = described_class.new(change)

        expect(decorator.first_paycheck).to be_nil
      end
    end
  end

  describe "#last_paycheck" do
    context "when there is a last_paycheck" do
      it "formats it" do
        change = create :change, last_paycheck: DateTime.new(2018, 2, 3, 19, 5, 6),
                                 member: member

        decorator = described_class.new(change)

        expect(decorator.last_paycheck).to eq "02/03/18"
      end
    end

    context "when there is not a last_paycheck" do
      it "returns nil" do
        change = create :change, last_paycheck: nil,
                                 member: member

        decorator = described_class.new(change)

        expect(decorator.last_paycheck).to be_nil
      end
    end
  end

  describe "#uploaded_proof" do
    context "when the client uploaded a verification document" do
      it "returns 'yes'" do
        document = fixture_file_upload(Rails.root.join("spec", "fixtures", "image.jpg"), "image/jpg")
        change = create :change, documents: [document],
                                 member: member

        decorator = described_class.new(change)

        expect(decorator.uploaded_proof).to eq "yes"
      end
    end

    context "when the client did not upload a verification document" do
      it "returns 'no'" do
        change = create :change, documents: [],
                                 member: member

        decorator = described_class.new(change)

        expect(decorator.uploaded_proof).to eq "no"
      end
    end
  end

  describe "#uploaded_proof_words_for_pdf" do
    context "when the client has one" do
      it "returns See attached" do
        document = fixture_file_upload(Rails.root.join("spec", "fixtures", "image.jpg"), "image/jpg")
        change = create :change, documents: [document],
                                 member: member

        decorator = described_class.new(change)

        expect(decorator.uploaded_proof_words_for_pdf).to eq "See attached"
      end
    end

    context "when the client does not have one" do
      it "returns Client does not have this" do
        change = create :change, documents: [],
                                 member: member

        decorator = described_class.new(change)

        expect(decorator.uploaded_proof_words_for_pdf).to eq "Client does not have this"
      end
    end
  end

  describe "#last_paycheck_amount" do
    context "when there is not an amount" do
      it "returns nil" do
        change = create :change, last_paycheck_amount: nil,
                                 member: member

        decorator = described_class.new(change)

        expect(decorator.last_paycheck_amount).to be_nil
      end
    end

    context "when there is an amount" do
      it "returns the formatted amount" do
        change = create :change, last_paycheck_amount: 1127.14, member: member

        decorator = described_class.new(change)

        expect(decorator.last_paycheck_amount).to eq "$1,127.14"
      end
    end
  end

  describe "#hourly_wage" do
    context "when there is an hourly_wage" do
      it "formats it" do
        change = create :change, hourly_wage: "50",
                                 member: member

        decorator = described_class.new(change)

        expect(decorator.hourly_wage).to eq "$50 /hr"
      end
    end

    context "when there is not an hourly_wage" do
      it "returns nil" do
        change = create :change, hourly_wage: nil,
                                 member: member

        decorator = described_class.new(change)

        expect(decorator.hourly_wage).to be_nil
      end
    end
  end

  describe "#change_in_hours_hours_a_week" do
    context "when only the lower hours are present" do
      it "returns the value" do
        change = create :change, lower_hours_a_week_amount: "5", upper_hours_a_week_amount: nil,
                                 member: member

        decorator = described_class.new(change)

        expect(decorator.change_in_hours_hours_a_week).to eq "5"
      end
    end

    context "when both the lower and upper hours are present" do
      it "returns the range" do
        change = create :change, lower_hours_a_week_amount: "5", upper_hours_a_week_amount: "15",
                                 member: member

        decorator = described_class.new(change)

        expect(decorator.change_in_hours_hours_a_week).to eq "5-15"
      end
    end
  end

  describe "#change_date" do
    context "when there is a change_date" do
      it "formats it" do
        change = create :change, change_date: DateTime.new(2018, 2, 3, 19, 5, 6),
                                 member: member

        decorator = described_class.new(change)

        expect(decorator.change_date).to eq "02/03/18"
      end
    end

    context "when there is not a change_date" do
      it "returns nil" do
        change = create :change, change_date: nil,
                                 member: member

        decorator = described_class.new(change)

        expect(decorator.change_date).to be_nil
      end
    end
  end

  describe "#job_termination" do
    context "when it is a job termination" do
      it "returns Yes" do
        change = create :change, change_type: "job_termination",
                                 member: member

        decorator = described_class.new(change)

        expect(decorator.job_termination).to eq "Yes"
      end
    end

    context "when it is not a job termination" do
      it "returns No" do
        change = create :change, change_type: "new_job",
                                 member: member

        decorator = described_class.new(change)

        expect(decorator.job_termination).to eq "No"
      end
    end
  end

  describe "#new_job" do
    context "when it is a new job" do
      it "returns Yes" do
        change = create :change, change_type: "new_job",
                                 member: member

        decorator = described_class.new(change)

        expect(decorator.new_job).to eq "Yes"
      end
    end

    context "when it is not a new job" do
      it "returns No" do
        change = create :change, change_type: "job_termination",
                                 member: member

        decorator = described_class.new(change)

        expect(decorator.new_job).to eq "No"
      end
    end
  end

  describe "#change_in_hours" do
    context "when it is a change in hours" do
      it "returns Yes" do
        change = create :change, change_type: "change_in_hours",
                                 member: member

        decorator = described_class.new(change)

        expect(decorator.change_in_hours).to eq "Yes"
      end
    end

    context "when it is not a change in hours" do
      it "returns No" do
        change = create :change, change_type: "new_job",
                                 member: member

        decorator = described_class.new(change)

        expect(decorator.change_in_hours).to eq "No"
      end
    end
  end

  describe "#paid_yet" do
    context "answered" do
      it "returns the paid_yet value" do
        change = create :change, paid_yet: "yes",
                                 member: member

        decorator = described_class.new(change)

        expect(decorator.paid_yet).to eq "yes"
      end
    end

    context "unfilled" do
      it "returns empty string" do
        change = create :change, paid_yet: "unfilled",
                                 member: member

        decorator = described_class.new(change)

        expect(decorator.paid_yet).to be_nil
      end
    end
  end

  describe "#same_hours" do
    context "answered" do
      it "returns the same_hours value" do
        change = create :change, same_hours: "yes",
                                 member: member

        decorator = described_class.new(change)

        expect(decorator.same_hours).to eq "yes"
      end
    end

    context "unfilled" do
      it "returns empty string" do
        change = create :change, same_hours: "unfilled",
                                 member: member

        decorator = described_class.new(change)

        expect(decorator.same_hours).to be_nil
      end
    end
  end

  describe "#ssn" do
    context "when there is a member with a ssn" do
      it "formats it" do
        member = create :member, report: report, ssn: "333224444"
        change = create :change, member: member

        decorator = described_class.new(change)

        expect(decorator.ssn).to eq "333-22-4444"
      end
    end

    context "when there is not a ssn" do
      it "returns nil" do
        member = create :member, report: report, ssn: ""
        change = create :change, member: member

        decorator = described_class.new(change)

        expect(decorator.ssn).to be_nil
      end
    end
  end

  describe "#birthday" do
    context "when there is a member with a birthday" do
      it "formats it" do
        birthday = DateTime.new(2018, 2, 3, 19, 5, 6)
        member = create :member, birthday: birthday,
                                 report: report
        change = create :change, member: member

        decorator = described_class.new(change)

        expect(decorator.birthday).to eq "02/03/18"
      end
    end

    context "when there is not a birthday" do
      it "returns nil" do
        member = create :member, birthday: nil, report: report
        change = create :change, member: member

        decorator = described_class.new(change)

        expect(decorator.birthday).to be_nil
      end
    end
  end

  describe "#client_name" do
    it "returns client full name" do
      member = create :member, report: report,
                               first_name: "Deep Dish", last_name: "Pizza"
      change = create :change, member: member

      decorator = described_class.new(change)

      expect(decorator.client_name).to eq "Deep Dish Pizza"
    end
  end

  describe "#client_phone_number" do
    context "when there is a phone_number" do
      it "formats it" do
        member = create :member, report: report,
                                 phone_number: "5553339999"
        change = create :change, member: member

        decorator = described_class.new(change)

        expect(decorator.client_phone_number).to eq "555-333-9999"
      end
    end

    context "when there is not a phone_number" do
      it "returns nil" do
        member = create :member, report: report,
                                 phone_number: ""
        change = create :change, member: member

        decorator = described_class.new(change)

        expect(decorator.client_phone_number).to be_nil
      end
    end
  end
end
