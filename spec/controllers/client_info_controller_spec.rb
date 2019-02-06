require "rails_helper"

RSpec.describe ClientInfoController do
  it_behaves_like "form controller base behavior"
  it_behaves_like "form controller successful update", {
    first_name: "Best",
    last_name: "Person",
    birthday_day: "15",
    birthday_month: "1",
    birthday_year: "2000",
  }
  it_behaves_like "form controller unsuccessful update"

  let(:report) { create :report, :filled }

  describe "#show" do
    context "the change doesn't have the client info yet" do
      it "shows" do
        report.current_member.update first_name: nil, last_name: nil, birthday: nil

        expect(described_class.show?(report)).to eq true
      end
    end

    context "the required fields of client haven't been answered yet" do
      it "shows" do
        report.current_member.update first_name: "Bacon", last_name: "Eggs", birthday: Date.today

        expect(described_class.show?(report)).to eq false
      end
    end
  end
end
