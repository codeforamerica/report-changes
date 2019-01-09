require "rails_helper"

describe TextConfirmationToClientJob do
  describe "#perform" do
    before do
      FakeSmsClient.clear
    end

    it "calls send on the SmsClient with the message, to, and from" do
      TextConfirmationToClientJob.perform_now(phone_number: "5554443333")

      expect(FakeSmsClient.sent_messages.count).to eq 1
      expect(FakeSmsClient.sent_messages.first.message).to include "Your change report has been submitted to Arapahoe County." # rubocop:disable Metrics/LineLength
      expect(FakeSmsClient.sent_messages.first.to).to include "5554443333"
      expect(FakeSmsClient.sent_messages.first.from).to include "15553338888"
    end
  end
end
