require "rails_helper"

RSpec.describe TellUsAboutYourselfForm do
  describe "validations" do
    let(:valid_params) do
      {
        phone_number: "1112223333",
        birthday_year: 2000,
        birthday_month: 1,
        birthday_day: 12,
      }
    end

    context "when all params are valid" do
      it "is valid" do
        form = TellUsAboutYourselfForm.new(nil, valid_params)

        expect(form).to be_valid
      end
    end

    describe "phone_number" do
      context "when the phone number includes dashes" do
        it "is valid" do
          params = valid_params.merge(phone_number: "111-222-3333")
          form = TellUsAboutYourselfForm.new(nil, params)

          expect(form).to be_valid
        end
      end

      context "when no phone number given" do
        it "is valid" do
          form = TellUsAboutYourselfForm.new(nil, valid_params.merge(phone_number: ""))

          expect(form).to be_valid
        end
      end

      context "when phone_number is less than 10 digits long" do
        it "is invalid" do
          invalid_params = valid_params.merge(phone_number: "111222333")
          form = TellUsAboutYourselfForm.new(nil, invalid_params)

          expect(form).to_not be_valid
        end
      end
    end

    describe "ssn" do
      context "when the ssn is not included" do
        it "is valid" do
          params = valid_params.merge(ssn: nil)
          form = TellUsAboutYourselfForm.new(nil, params)

          expect(form).to be_valid
        end
      end

      context "when the ssn is included and is 9 digits long" do
        it "is valid" do
          params = valid_params.merge(ssn: "111223333")
          form = TellUsAboutYourselfForm.new(nil, params)

          expect(form).to be_valid
        end
      end

      context "when the ssn includes dashes" do
        it "is valid" do
          params = valid_params.merge(ssn: "111-22-3333")
          form = TellUsAboutYourselfForm.new(nil, params)

          expect(form).to be_valid
        end
      end

      context "when the ssn is included but is not 9 digits long" do
        it "is invalid" do
          invalid_params = valid_params.merge(ssn: "11122333")
          form = TellUsAboutYourselfForm.new(nil, invalid_params)

          expect(form).to_not be_valid
        end
      end
    end

    describe "birthday" do
      context "when the birthday is not included" do
        it "is invalid" do
          invalid_params = valid_params.merge(
            birthday_year: nil,
            birthday_month: nil,
            birthday_day: nil,
          )
          form = TellUsAboutYourselfForm.new(nil, invalid_params)

          expect(form).to_not be_valid
          expect(form.errors[:birthday].count).to eq 1
          expect(form.errors[:birthday].first).to eq "Please add a month, a day, and a year."
        end
      end

      context "when the birthday is not included" do
        it "is invalid" do
          invalid_params = valid_params.merge(
            birthday_year: 2000,
            birthday_month: 2,
            birthday_day: nil,
          )
          form = TellUsAboutYourselfForm.new(nil, invalid_params)

          expect(form).to_not be_valid
          expect(form.errors[:birthday].count).to eq 1
          expect(form.errors[:birthday].first).to eq "Please add a day."
          expect(form.birthday_year).to eq 2000
        end
      end

      context "when the birthday is not a valid date" do
        it "is invalid" do
          form = TellUsAboutYourselfForm.new(nil,
            birthday_year: 1992,
            birthday_month: 2,
            birthday_day: 30)

          expect(form).not_to be_valid
          expect(form.errors[:birthday].count).to eq 1
          expect(form.errors[:birthday].first).to eq "Please provide a real date."
        end
      end
    end
  end

  describe "#save" do
    let(:valid_params) do
      {
        phone_number: "111-222-3333",
        ssn: "111-22-3333",
        case_number: "123abc",
        birthday_day: "15",
        birthday_month: "1",
        birthday_year: "2000",
      }
    end

    it "persists the values to the correct models" do
      change_report = create(:change_report, :with_member)
      form = TellUsAboutYourselfForm.new(change_report, valid_params)
      form.valid?
      form.save

      change_report.reload

      expect(change_report.case_number).to eq "123abc"
      expect(change_report.phone_number).to eq "1112223333"
      expect(change_report.member.ssn).to eq "111223333"
      expect(change_report.member.birthday.year).to eq 2000
      expect(change_report.member.birthday.month).to eq 1
      expect(change_report.member.birthday.day).to eq 15
    end
  end

  describe ".from_change_report" do
    it "assigns values from change report and other objects" do
      change_report = create(:change_report,
        case_number: "1A1234",
        phone_number: "1234567890",
        member: build(:household_member,
          ssn: "111223333",
          birthday: DateTime.new(1950, 1, 31)))

      form = TellUsAboutYourselfForm.from_change_report(change_report)

      expect(form.birthday_year).to eq(1950)
      expect(form.birthday_month).to eq(1)
      expect(form.birthday_day).to eq(31)
      expect(form.phone_number).to eq("1234567890")
      expect(form.ssn).to eq("111223333")
      expect(form.case_number).to eq("1A1234")
    end
  end
end
