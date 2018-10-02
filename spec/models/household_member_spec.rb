require "rails_helper"

RSpec.describe HouseholdMember, type: :model do
  describe "#age" do
    let(:member) { create :household_member, birthday: 100.years.ago - 6.months }

    it "returns the age of the person" do
      expect(member.age).to eq 100
    end
  end
end
