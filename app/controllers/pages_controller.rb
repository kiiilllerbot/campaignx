class PagesController < ApplicationController
  before_action :authenticate_user!, only: [:dashboard]

  def dashboard
    all_broadcasts = Broadcast.where(user_id: current_user.id)
    @broadcasts = Kaminari.paginate_array(all_broadcasts).page(params[:page]).per(25)
  end
end
