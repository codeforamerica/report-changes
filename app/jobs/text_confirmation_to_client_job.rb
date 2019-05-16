class TextConfirmationToClientJob < ApplicationJob
  def perform(phone_number:)
    Twilio::REST::Client.new.studio.flows("FW00aff42f48d3eb6a6e4c5375c716d588").executions.create(
      to: phone_number,
      from: "+12564084607",
    )
  end
end
