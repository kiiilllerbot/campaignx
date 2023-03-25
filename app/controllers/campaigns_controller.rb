class CampaignsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_campaign, only: %i[ show ]

  require "bitly"
  require 'vonage'

  def index
    all_campaigns = Campaign.all.order(created_at: :desc)
    @campaigns = Kaminari.paginate_array(all_campaigns).page(params[:page]).per(10)
  end

  def show
    all_broadcasts = Broadcast.all.where(campaign_id: @campaign.id).order(created_at: :desc)
    @broadcasts = Kaminari.paginate_array(all_broadcasts).page(params[:page]).per(10)
  end

  def new
    @campaign = current_user.campaigns.build
  end

  def create
    if current_user.wallet.balance > current_user.audiences.count
      @campaign = current_user.campaigns.build(campaign_params)
      url = params[:campaign][:url]

      if url.present? && valid_url?(url)
        begin
          client = Bitly::API::Client.new(token: '6038f593b082f2b5811a944da9e644814a131a12')
          bitlink = client.shorten(long_url: url)
          short_url = bitlink.link

          rescue Bitly::Error => e
            logger.error("Bitly API Error: #{e.message}")

            flash[:error] = "Failed to create Campaign"
              redirect_to root_path
            return url
          end

        else
        short_url = ''
      end

      @campaign.short_url = short_url
      @full_message = "#{@campaign.title} #{@campaign.message} #{@campaign.short_url}"

      respond_to do |format|
        if @campaign.save
          audiences = current_user.audiences.all

          audiences.each do |audience|
            # Send SMS
            client = Vonage::Client.new(api_key: '08b0e4dc', api_secret: 'whKYHVysVMO8Eh49')
            response = client.sms.send(
              from: '0174216717',
              to: audience.contact_number,
              text: @full_message
            )

            message_id = response["messages"][0]["message_id"]
            if response["messages"][0]["status"] == "0"
              puts "SMS sent successfully."
            else
              puts "SMS failed to send."
            end

            Broadcast.create(
              receiver_name: audience.name,
              receiver_email: audience.email,
              receiver_contact_number: audience.contact_number,
              user_id: current_user.id,
              campaign_id: @campaign.id,
              message_id: message_id
            )
            
            BroadcastWorker.perform_in(1.minute, current_user.id, audience.id, @campaign.title, @full_message)
          end

          # Update wallet
          total_charge = current_user.audiences.count
          wallet = current_user.wallet
          wallet_balance = wallet.balance
          wallet.update_attribute(:balance, wallet_balance - total_charge)

          format.html { redirect_to campaign_url(@campaign), notice: "Campaign was successfully created." }
          format.json { render :show, status: :created, location: @campaign }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @campaign.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to root_path, alert: 'Insufficient wallet balance'
    end
  end

  private
    def set_campaign
      @campaign = Campaign.find(params[:id])
    end

    def campaign_params
      params.require(:campaign).permit(:title, :message, :url, :short_url, :clicks, :user_id)
    end

    def valid_url?(url)
      return false if url.include?("<script")
      url_regexp = /\A(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?\z/ix
      url =~ url_regexp ? true : false
  end
end
