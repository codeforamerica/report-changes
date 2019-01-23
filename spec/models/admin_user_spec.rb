require "rails_helper"

RSpec.describe AdminUser do
  describe "#active_for_authentication?" do
    context "user has signed in within the last 90 days" do
      it "returns true" do
        user = create(:admin_user, last_sign_in_at: 1.day.ago)
        expect(user.active_for_authentication?).to be_truthy
      end
    end

    context "user has not signed in within the last 90 days" do
      it "returns false" do
        user = create(:admin_user, last_sign_in_at: 91.day.ago)
        expect(user.active_for_authentication?).to eq(false)
      end
    end

    context "user has never signed in before" do
      it "returns true" do
        user = create(:admin_user, last_sign_in_at: nil)
        expect(user.active_for_authentication?).to be_truthy
      end
    end
  end
end
