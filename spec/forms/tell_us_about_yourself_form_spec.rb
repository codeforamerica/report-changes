require "rails_helper"

RSpec.describe TellUsAboutYourselfForm do
  describe "validations" do
    let(:valid_params) do
      {
        name: "Jane Doe",
        phone_number: "1112223333",
        birthday_year: 2000,
        birthday_month: 1,
        birthday_day: 12,
      }
    end

    context "when all params are valid" do
      it "is valid" do
        form = TellUsAboutYourselfForm.new(valid_params)

        expect(form).to be_valid
      end
    end

    describe "name" do
      context "when the name is not included" do
        it "is invalid" do
          invalid_params = valid_params.merge(name: nil)
          form = TellUsAboutYourselfForm.new(invalid_params)

          expect(form).to_not be_valid
        end
      end
    end

    describe "phone_number" do
      context "when the phone number includes dashes" do
        it "is valid" do
          params = valid_params.merge(phone_number: "111-222-3333")
          form = TellUsAboutYourselfForm.new(params)

          expect(form).to be_valid
        end
      end

      context "when the phone_number is not included" do
        it "is invalid" do
          invalid_params = valid_params.merge(phone_number: nil)
          form = TellUsAboutYourselfForm.new(invalid_params)

          expect(form).to_not be_valid
        end
      end

      context "when phone_number is less than 10 digits long" do
        it "is invalid" do
          invalid_params = valid_params.merge(phone_number: "111222333")
          form = TellUsAboutYourselfForm.new(invalid_params)

          expect(form).to_not be_valid
        end
      end
    end

    describe "ssn" do
      context "when the ssn is not included" do
        it "is valid" do
          params = valid_params.merge(ssn: nil)
          form = TellUsAboutYourselfForm.new(params)

          expect(form).to be_valid
        end
      end

      context "when the ssn is included and is 9 digits long" do
        it "is valid" do
          params = valid_params.merge(ssn: "111223333")
          form = TellUsAboutYourselfForm.new(params)

          expect(form).to be_valid
        end
      end

      context "when the ssn includes dashes" do
        it "is valid" do
          params = valid_params.merge(ssn: "111-22-3333")
          form = TellUsAboutYourselfForm.new(params)

          expect(form).to be_valid
        end
      end

      context "when the ssn is included but is not 9 digits long" do
        it "is invalid" do
          invalid_params = valid_params.merge(ssn: "11122333")
          form = TellUsAboutYourselfForm.new(invalid_params)

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
          form = TellUsAboutYourselfForm.new(invalid_params)

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
          form = TellUsAboutYourselfForm.new(invalid_params)

          expect(form).to_not be_valid
          expect(form.errors[:birthday].count).to eq 1
          expect(form.errors[:birthday].first).to eq "Please add a day."
          expect(form.birthday_year).to eq 2000
        end
      end

      context "when the birthday is not a valid date" do
        it "is invalid" do
          form = TellUsAboutYourselfForm.new(birthday_year: 1992, birthday_month: 2, birthday_day: 30)

          expect(form).not_to be_valid
          expect(form.errors[:birthday].count).to eq 1
          expect(form.errors[:birthday].first).to eq "Please provide a real birthday."
        end
      end
    end
  end
end
