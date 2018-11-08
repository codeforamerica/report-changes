require "rails_helper"

RSpec.describe HouseholdMember, type: :model do
  describe "#age" do
    context "when birthday is present" do
      it "returns the age of the person" do
        member = create(:household_member, birthday: 100.years.ago - 6.months)
        expect(member.age).to eq 100
      end
    end

    context "when birthday is not present" do
      it "returns nil" do
        member = create(:household_member)
        expect(member.age).to be_nil
      end
    end
  end
end
