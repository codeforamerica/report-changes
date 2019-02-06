require "rails_helper"

RSpec.describe WhoHadChangeForm do
  describe "validations" do
    context "when new_or_existing_member is provided" do
      it "is valid" do
        form = WhoHadChangeForm.new(
          nil,
          new_or_existing_member: "new_submitter",
        )

        expect(form).to be_valid
      end
    end

    context "when new_or_existing_member is not provided" do
      it "is invalid" do
        form = WhoHadChangeForm.new(
          nil,
          new_or_existing_member: nil,
        )

        expect(form).not_to be_valid
        expect(form.errors[:new_or_existing_member]).to be_present
      end
    end
  end

  describe "#save" do
    context "new_submitter" do
      context "with out a submitter reported yet" do
        it "creates a new submitter for the change" do
          report = create :report
          create :navigator, report: report

          form = WhoHadChangeForm.new(report, { new_or_existing_member: "new_submitter" })

          expect { form.save }.to(change { report.members.count }.from(0).to(1))
          expect(report.current_member.is_submitter).to be_truthy
        end
      end

      context "with a submitter already reported" do
        it "uses the existing submitter for the change" do
          report = create :report, :filled
          report.current_member.update is_submitter: true

          form = WhoHadChangeForm.new(report, { new_or_existing_member: "existing_member_#{report.current_member.id}" })
          form.save

          expect(report.members.count).to eq 1
          expect(report.current_member.is_submitter).to be_truthy
          expect(report.reported_changes.first.member == report.reported_changes.second.member)
        end
      end
    end

    context "new_someone_else" do
      context "with out anyone reported yet" do
        it "creates a new member for the change" do
          report = create :report
          create :navigator, report: report

          form = WhoHadChangeForm.new(report, { new_or_existing_member: "new_someone_else" })

          expect { form.save }.to(change { report.members.count }.from(0).to(1))
          expect(report.current_member.is_submitter).to be_falsey
        end
      end

      context "with that person already reported" do
        it "uses the existing member for the change" do
          report = create :report, :filled
          report.current_member.update is_submitter: false

          form = WhoHadChangeForm.new(report, { new_or_existing_member: "existing_member_#{report.current_member.id}" })
          form.save

          expect(report.members.count).to eq 1
          expect(report.current_member.is_submitter).to be_falsey
        end
      end
    end
  end

  describe ".from_report" do
    it "assigns values from change report" do
      report = create :report, :filled

      form = WhoHadChangeForm.from_report(report)

      expect { form.save }.not_to(change { report.members.count })
      expect(form.new_or_existing_member).to eq "existing_member_#{report.current_member.id}"
    end
  end
end
