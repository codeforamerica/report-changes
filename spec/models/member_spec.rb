require "rails_helper"

RSpec.describe Member, type: :model do
  describe "#age" do
    context "when birthday is present" do
      it "returns the age of the person" do
        member = create(:member, birthday: 100.years.ago - 6.months)
        expect(member.age).to eq 100
      end
    end

    context "when birthday is not present" do
      it "returns nil" do
        member = create(:member)
        expect(member.age).to be_nil
      end
    end
  end

  describe "#full_name" do
    context "when first and last name present" do
      it "returns the first and last name of the member" do
        member = build(:member, first_name: "christa", last_name: "person")
        expect(member.full_name).to eq("christa person")
      end
    end
  end
end
