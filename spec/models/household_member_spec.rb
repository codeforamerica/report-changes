require "rails_helper"

RSpec.describe HouseholdMember, type: :model do
  describe "#age" do
    it "returns the age of the person" do
      member = create(:household_member, birthday: 100.years.ago - 6.months)
      expect(member.age).to eq 100
    end
  end

  describe "#name" do
    it "returns first and last name of the person" do
      member = create(:household_member, first_name: "princess", last_name: "caroline")

      expect(member.full_name).to eq("princess caroline")
    end
  end
end
