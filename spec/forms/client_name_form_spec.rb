require "rails_helper"

RSpec.describe ClientNameForm do
  describe "validations" do
    context "when all required attributes are provided" do
      it "is valid" do
        form = ClientNameForm.new(
          nil,
          first_name: "Annie",
          last_name: "McDog",
        )

        expect(form).to be_valid
      end
    end

    context "when first_name is not provided" do
      it "is invalid" do
        form = ClientNameForm.new(
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
        form = ClientNameForm.new(
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
      }
    end

    context "when the member does not yet exist" do
      it "creates member with given values" do
        change_report = create(:change_report)
        form = ClientNameForm.new(change_report, valid_params)
        form.valid?
        form.save

        change_report.reload

        expect(change_report.member.first_name).to eq "Annie"
        expect(change_report.member.last_name).to eq "McDog"
      end
    end

    context "when the member already exists" do
      it "updates the member" do
        change_report = create(:change_report, :with_member, first_name: "Sophie")
        form = ClientNameForm.new(change_report, valid_params)

        expect do
          form.save
        end.not_to(change { HouseholdMember.count })

        change_report.reload

        expect(change_report.member.first_name).to eq "Annie"
      end
    end
  end

  describe ".from_change_report" do
    context "when member exists" do
      it "assigns values from change report and other objects" do
        change_report = create(:change_report,
                               member: build(:household_member, first_name: "Annie", last_name: "McDog"))

        form = ClientNameForm.from_change_report(change_report)

        expect(form.first_name).to eq("Annie")
        expect(form.last_name).to eq("McDog")
      end
    end

    context "when member does not exist" do
      it "assigns an empty hash" do
        form = ClientNameForm.from_change_report(create(:change_report))

        expect(form.first_name).to be_nil
        expect(form.last_name).to be_nil
      end
    end
  end
end
