require "rails_helper"

RSpec.describe ChangeDecorator do
  describe "#manager_phone_number" do
    context "when there is a manager_phone_number" do
      it "formats it" do
        change = create :change, manager_phone_number: "5553339999"

        decorator = ChangeDecorator.new(change)

        expect(decorator.manager_phone_number).to eq "555-333-9999"
      end
    end

    context "when there is not a manager_phone_number" do
      it "returns nil" do
        change = create :change, manager_phone_number: nil

        decorator = ChangeDecorator.new(change)

        expect(decorator.manager_phone_number).to be_nil
      end
    end
  end

  describe "#last_day" do
    context "when there is a last_day" do
      it "formats it" do
        change = create :change, last_day: DateTime.new(2018, 2, 3, 19, 5, 6)

        decorator = ChangeDecorator.new(change)

        expect(decorator.last_day).to eq "02/03/18"
      end
    end

    context "when there is not a last_day" do
      it "returns nil" do
        change = create :change, last_day: nil

        decorator = ChangeDecorator.new(change)

        expect(decorator.last_day).to be_nil
      end
    end
  end

  describe "#last_paycheck" do
    context "when there is a last_paycheck" do
      it "formats it" do
        change = create :change, last_paycheck: DateTime.new(2018, 2, 3, 19, 5, 6)

        decorator = ChangeDecorator.new(change)

        expect(decorator.last_paycheck).to eq "02/03/18"
      end
    end

    context "when there is not a last_paycheck" do
      it "returns nil" do
        change = create :change, last_paycheck: nil

        decorator = ChangeDecorator.new(change)

        expect(decorator.last_paycheck).to be_nil
      end
    end
  end

  describe "#uploaded_proof" do
    context "when the client uploaded a verification document" do
      it "returns 'yes'" do
        document = fixture_file_upload(Rails.root.join("spec", "fixtures", "image.jpg"), "image/jpg")
        change = create :change, documents: [document]

        decorator = ChangeDecorator.new(change)

        expect(decorator.uploaded_proof).to eq "yes"
      end
    end

    context "when the client did not upload a verification document" do
      it "returns 'no'" do
        change = create :change, documents: []

        decorator = ChangeDecorator.new(change)

        expect(decorator.uploaded_proof).to eq "no"
      end
    end
  end

  describe "#uploaded_proof_words_for_pdf" do
    context "when the client has one" do
      it "returns See attached" do
        document = fixture_file_upload(Rails.root.join("spec", "fixtures", "image.jpg"), "image/jpg")
        change = create :change, documents: [document]

        decorator = ChangeDecorator.new(change)

        expect(decorator.uploaded_proof_words_for_pdf).to eq "See attached"
      end
    end

    context "when the client does not have one" do
      it "returns Client does not have this" do
        change = create :change, documents: []

        decorator = ChangeDecorator.new(change)

        expect(decorator.uploaded_proof_words_for_pdf).to eq "Client does not have this"
      end
    end
  end

  describe "#last_paycheck_amount" do
    context "when there is not an amount" do
      it "returns nil" do
        change = create :change, last_paycheck_amount: nil

        decorator = ChangeDecorator.new(change)

        expect(decorator.last_paycheck_amount).to be_nil
      end
    end

    context "when there is an amount" do
      it "returns the formatted amount" do
        change = create :change, last_paycheck_amount: 1127.14

        decorator = ChangeDecorator.new(change)

        expect(decorator.last_paycheck_amount).to eq "$1,127.14"
      end
    end
  end

  describe "#hourly_wage" do
    context "when there is an hourly_wage" do
      it "formats it" do
        change = create :change, hourly_wage: "50"

        decorator = ChangeDecorator.new(change)

        expect(decorator.hourly_wage).to eq "$50 /hr"
      end
    end

    context "when there is not an hourly_wage" do
      it "returns nil" do
        change = create :change, hourly_wage: nil

        decorator = ChangeDecorator.new(change)

        expect(decorator.hourly_wage).to be_nil
      end
    end
  end

  describe "#change_in_hours_hours_a_week" do
    context "when only the lower hours are present" do
      it "returns the value" do
        change = create :change, lower_hours_a_week_amount: "5", upper_hours_a_week_amount: nil

        decorator = ChangeDecorator.new(change)

        expect(decorator.change_in_hours_hours_a_week).to eq "5"
      end
    end

    context "when both the lower and upper hours are present" do
      it "returns the range" do
        change = create :change, lower_hours_a_week_amount: "5", upper_hours_a_week_amount: "15"

        decorator = ChangeDecorator.new(change)

        expect(decorator.change_in_hours_hours_a_week).to eq "5-15"
      end
    end
  end

  describe "#change_date" do
    context "when there is a change_date" do
      it "formats it" do
        change = create :change, change_date: DateTime.new(2018, 2, 3, 19, 5, 6)

        decorator = ChangeDecorator.new(change)

        expect(decorator.change_date).to eq "02/03/18"
      end
    end

    context "when there is not a change_date" do
      it "returns nil" do
        change = create :change, change_date: nil

        decorator = ChangeDecorator.new(change)

        expect(decorator.change_date).to be_nil
      end
    end
  end

  describe "#job_termination" do
    context "when it is a job termination" do
      it "returns Yes" do
        change = create :change, change_type: "job_termination"

        decorator = ChangeDecorator.new(change)

        expect(decorator.job_termination).to eq "Yes"
      end
    end

    context "when it is not a job termination" do
      it "returns No" do
        change = create :change, change_type: "new_job"

        decorator = ChangeDecorator.new(change)

        expect(decorator.job_termination).to eq "No"
      end
    end
  end

  describe "#new_job" do
    context "when it is a new job" do
      it "returns Yes" do
        change = create :change, change_type: "new_job"

        decorator = ChangeDecorator.new(change)

        expect(decorator.new_job).to eq "Yes"
      end
    end

    context "when it is not a new job" do
      it "returns No" do
        change = create :change, change_type: "job_termination"

        decorator = ChangeDecorator.new(change)

        expect(decorator.new_job).to eq "No"
      end
    end
  end

  describe "#change_in_hours" do
    context "when it is a change in hours" do
      it "returns Yes" do
        change = create :change, change_type: "change_in_hours"

        decorator = ChangeDecorator.new(change)

        expect(decorator.change_in_hours).to eq "Yes"
      end
    end

    context "when it is not a change in hours" do
      it "returns No" do
        change = create :change, change_type: "new_job"

        decorator = ChangeDecorator.new(change)

        expect(decorator.change_in_hours).to eq "No"
      end
    end
  end

  describe "#paid_yet" do
    context "answered" do
      it "returns the paid_yet value" do
        change = create :change, paid_yet: "yes"

        decorator = ChangeDecorator.new(change)

        expect(decorator.paid_yet).to eq "yes"
      end
    end

    context "unfilled" do
      it "returns empty string" do
        change = create :change, paid_yet: "unfilled"

        decorator = ChangeDecorator.new(change)

        expect(decorator.paid_yet).to be_nil
      end
    end
  end

  describe "#same_hours" do
    context "answered" do
      it "returns the same_hours value" do
        change = create :change, same_hours: "yes"

        decorator = ChangeDecorator.new(change)

        expect(decorator.same_hours).to eq "yes"
      end
    end

    context "unfilled" do
      it "returns empty string" do
        change = create :change, same_hours: "unfilled"

        decorator = ChangeDecorator.new(change)

        expect(decorator.same_hours).to be_nil
      end
    end
  end
end
