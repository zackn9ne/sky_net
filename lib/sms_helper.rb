class SmsHelper
  def self.quick_send(content, recipient)
    send_text_message

    @twilio_client.account.sms.messages.create(
        :from => "+1#{@twilio_phone_number}",
        :to => recipient,
        :body => content
    )
  end
  def self.send_text_message #(param1, param2)
    number_to_send_to =  Rails.application.secrets.cell_phone

    twilio_sid = "ACbbd0943e17312304cbdd5b07f0891fa4"
    twilio_token =  Rails.application.secrets.twilio
    @twilio_phone_number = Rails.application.secrets.twilio_phone

    twilio_client = Twilio::REST::Client.new twilio_sid, twilio_token
    @twilio_client = twilio_client
  end
end