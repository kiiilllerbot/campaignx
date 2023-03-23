class AudiencesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_audience, only: %i[ show edit update destroy ]

  def index
    all_audiences = Audience.all.order(created_at: :desc)
    @audiences = Kaminari.paginate_array(all_audiences).page(params[:page]).per(10)
  end

  def show
  end

  def new
    @audience = current_user.audiences.build
  end

  def edit
  end

  def create
    @audience = current_user.audiences.build(audience_params)

    respond_to do |format|
      if @audience.save
        format.html { redirect_to audience_url(@audience), notice: "Audience was successfully created." }
        format.json { render :show, status: :created, location: @audience }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @audience.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @audience.update(audience_params)
        format.html { redirect_to audience_url(@audience), notice: "Audience was successfully updated." }
        format.json { render :show, status: :ok, location: @audience }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @audience.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @audience.destroy

    respond_to do |format|
      format.html { redirect_to audiences_url, notice: "Audience was successfully deleted." }
      format.json { head :no_content }
    end
  end

  private
    def set_audience
      @audience = Audience.find(params[:id])
    end

    def audience_params
      params.require(:audience).permit(:name, :email, :contact_number, :user_id)
    end
end
