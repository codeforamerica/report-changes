require "rails_helper"

RSpec.describe WhoHadChangeController do
  it_behaves_like "form controller base behavior"
  it_behaves_like "form controller unsuccessful update"
  it_behaves_like "form controller always shows"
  it_behaves_like "form controller successful update", {
    new_or_existing_member: "new_submitter",
  }

  let(:report) { create :report, :filled }
  before { session[:current_report_id] = report.id }

  describe "#who_had_change_collection" do
    context "with no people reported yet" do
      it "returns the first few options" do
        new_member_choices = [
          { value: "new_submitter", label: "Me" },
          { value: "new_someone_else", label: "Someone in my household" },
        ]
        expect(controller.who_had_change_collection).to eq new_member_choices
      end
    end

    context "with only submitter reported so far" do
      it "returns the first few options" do
        report.current_member.update is_submitter: true

        existing_submitter_choices = [
          { value: "existing_member_#{report.current_member.id}", label: "Me" },
          { value: "new_someone_else", label: "Someone in my household" },
        ]
        expect(controller.who_had_change_collection).to eq existing_submitter_choices
      end
    end

    context "with changes reported for others already" do
      it "returns the first few options" do
        report.current_member.update is_submitter: false, first_name: "Chili", last_name: "Burger"

        choices = [
          { value: "new_submitter", label: "Me" },
          { value: "existing_member_#{report.current_member.id}", label: "Chili Burger" },
          { value: "new_someone_else", label: "Someone else in my household" },
        ]
        expect(controller.who_had_change_collection).to eq choices
      end
    end
  end

  describe "#clear_empty_members" do
    it "clears out the empty members" do
      create :member, first_name: nil, last_name: nil, birthday: nil, report: report
      create :member, first_name: nil, last_name: nil, birthday: nil, report: report
      create :member, first_name: "Frank", last_name: "Ocean", birthday: Date.today, report: report

      get :edit

      expect(report.members.count).to eq 1
    end
  end

  describe "#clear_empty_changes" do
    it "clears out the empty changes" do
      member = create :member, first_name: "Frank", last_name: "Ocean", birthday: Date.today, report: report
      create :change, change_navigator: create(:change_navigator, has_documents: :unfilled), member: member
      create :change, change_navigator: create(:change_navigator, has_documents: :unfilled), member: member
      create :change, change_navigator: create(:change_navigator, has_documents: :unfilled), member: member
      create :change, change_navigator: create(:change_navigator, has_documents: :yes), member: member

      get :edit

      expect(report.reported_changes.count).to eq 1
    end
  end
end
