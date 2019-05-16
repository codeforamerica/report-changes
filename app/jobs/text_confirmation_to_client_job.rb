class TextConfirmationToClientJob < ApplicationJob
  def perform(phone_number:)
    Twilio::REST::Client.new.studio.flows(ENV["TWILIO_STUDIO_FLOW"]).executions.create(
      to: phone_number,
      from: ENV["TWILIO_PHONE_NUMBER"],
    )
  end
end
