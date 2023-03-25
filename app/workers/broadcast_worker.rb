class BroadcastWorker
  include Sidekiq::Worker

  def perform(sender_id, audience_id, subject, message)
    @sender = User.find_by_id(sender_id).email
    @audience = Audience.find_by_id(audience_id).email
    @subject = subject
    @message = message
    BroadcastMailer.send_email(@sender, @audience, @subject, @message).deliver_now
  end
end