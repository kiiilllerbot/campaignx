class CampaignsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_campaign, only: %i[ show ]

  def index
    all_campaigns = Campaign.all.order(created_at: :desc)
    @campaigns = Kaminari.paginate_array(all_campaigns).page(params[:page]).per(10)
  end

  def show
  end

  def new
    @campaign = current_user.campaigns.build
  end

  def create
    @campaign = current_user.campaigns.build(campaign_params)

    respond_to do |format|
      if @campaign.save
        format.html { redirect_to campaign_url(@campaign), notice: "Campaign was successfully created." }
        format.json { render :show, status: :created, location: @campaign }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @campaign.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def set_campaign
      @campaign = Campaign.find(params[:id])
    end

    def campaign_params
      params.require(:campaign).permit(:title, :message, :url, :short_url, :clicks, :user_id)
    end
end
