require "rails_helper"

RSpec.describe "form navigation routing" do
  context "in production" do
    before do
      allow(Rails).to receive(:env) { "production".inquiry }
      Rails.application.reload_routes!
    end

    after do
      allow(Rails).to receive(:env).and_call_original
      Rails.application.reload_routes!
    end

    it "blocks access to screens index" do
      expect(get: "/screens").not_to be_routable
    end
  end

  context "outside of production" do
    it "grants access to screens index" do
      expect(get: "/screens").to be_routable
    end
  end
end
