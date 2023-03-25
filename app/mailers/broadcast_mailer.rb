class BroadcastMailer < ApplicationMailer
  def send_email(sender, audience, subject, message)
    @message = message
    mail(from:sender, to: audience, subject: subject, message: message)
  end
end
