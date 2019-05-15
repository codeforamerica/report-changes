require "rails_helper"

describe TextConfirmationToClientJob do
  describe "#perform" do
    it "calls send on the SmsClient with the message, to, and from" do
      twilio_api = instance_double("Twilio::REST::Client")
      allow(Twilio::REST::Client).to receive(:new).and_return twilio_api
      allow(twilio_api).to receive_message_chain(:studio, :flows, :executions, :create)

      TextConfirmationToClientJob.perform_now(phone_number: "5554443333")

      expect(Twilio::REST::Client).to have_received(:new)
      expect(twilio_api).to have_received(:studio)
    end
  end
end
