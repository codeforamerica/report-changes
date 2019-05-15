class TextConfirmationToClientJob < ApplicationJob
  def perform(phone_number:)
    unless Rails.env.test?
      Twilio::REST::Client.new.studio.flows("FW335afc37e2d22e5ee70dce44ab66cddd").executions.create(
        to: phone_number,
        from: "+17207535874",
      )
    end
  end
end
