class SmsDeliveryReceiptsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    Broadcast.where(message_id: params[:messageId])
    .update_all(message_status: params[:status]) if params[:messageId]

    head :ok
  end
end