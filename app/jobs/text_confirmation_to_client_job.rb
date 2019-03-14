class TextConfirmationToClientJob < ApplicationJob
  def perform(phone_number:)
    message = "Your change report has been submitted to your county. " +
      "It'll be reviewed to see if your benefits need to change. " +
      "Reply to this msg any time for more info."

    SmsClient.send(to: phone_number,
                   from: CredentialsHelper.twilio_phone_number,
                   message: message)
  end
end
