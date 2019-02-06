require "rails_helper"

RSpec.describe ClientInfoForm do
  let(:report) { create :report, :filled }

  describe "validations" do
    context "when all required attributes are provided" do
      it "is valid" do
        form = ClientInfoForm.new(
          nil,
          first_name: "Annie",
          last_name: "McDog",
          birthday_year: 2000,
          birthday_month: 1,
          birthday_day: 12,
        )

        expect(form).to be_valid
      end
    end

    context "when first_name is not provided" do
      it "is invalid" do
        form = ClientInfoForm.new(
          nil,
          first_name: nil,
          last_name: "McDog",
        )

        expect(form).not_to be_valid
        expect(form.errors[:first_name]).to be_present
      end
    end

    context "when last_name is not provided" do
      it "is invalid" do
        form = ClientInfoForm.new(
          nil,
          first_name: "McDog",
          last_name: nil,
        )

        expect(form).not_to be_valid
        expect(form.errors[:last_name]).to be_present
      end
    end
  end

  describe "#save" do
    let(:valid_params) do
      {
        first_name: "Annie",
        last_name: "McDog",
        birthday_year: 2000,
        birthday_month: 1,
        birthday_day: 12,
      }
    end

    it "updates the member" do
      report.current_member.update first_name: "Sophie"

      form = ClientInfoForm.new(report, valid_params)

      expect do
        form.save
      end.not_to(change { Member.count })

      expect(report.current_member.first_name).to eq "Annie"
    end
  end

  describe ".from_report" do
    context "when member exists" do
      it "assigns values from change report and other objects" do
        report.current_member.update first_name: "Annie", last_name: "McDog", birthday: Date.new(2000, 1, 31)

        form = ClientInfoForm.from_report(report)

        expect(form.first_name).to eq("Annie")
        expect(form.last_name).to eq("McDog")
        expect(form.birthday_year).to eq(2000)
        expect(form.birthday_month).to eq(1)
        expect(form.birthday_day).to eq(31)
      end
    end

    context "when member does not exist" do
      it "assigns an empty hash" do
        report.navigator.update current_member: nil

        form = ClientInfoForm.from_report(report)

        expect(form.first_name).to be_nil
        expect(form.last_name).to be_nil
      end
    end
  end
end
