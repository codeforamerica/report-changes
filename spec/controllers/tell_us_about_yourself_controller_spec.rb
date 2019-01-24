require "rails_helper"

RSpec.describe TellUsAboutYourselfController do
  it_behaves_like "form controller base behavior"
  it_behaves_like "form controller successful update", {
    phone_number: "111-222-3333",
    ssn: "111-22-3333",
    case_number: "123abc",
    birthday_day: "15",
    birthday_month: "1",
    birthday_year: "2000",
  }
  it_behaves_like "form controller unsuccessful update"

  describe "#show" do
    context "the required field of birthday hasn't been answered yet" do
      it "shows" do
        report = create :report, member: build(:member, birthday: nil)

        expect(TellUsAboutYourselfController.show?(report)).to eq true
      end
    end

    context "the required field of birthday hasn't been answered yet" do
      it "shows" do
        report = create :report, member: build(:member, birthday: Date.today)

        expect(TellUsAboutYourselfController.show?(report)).to eq false
      end
    end
  end
end
