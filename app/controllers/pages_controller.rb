class PagesController < ApplicationController
  before_action :authenticate_user!, only: [:dashboard]

  def dashboard
    @all_broadcasts = Broadcast.where(user_id: current_user.id)
    @broadcasts = Kaminari.paginate_array(@all_broadcasts).page(params[:page]).per(25)
  end

  def transactions
    @all_transactions = Transaction.where(user_id: current_user.id).order(created_at: :desc)
    @transactions = Kaminari.paginate_array(@all_transactions).page(params[:page]).per(10)
  end
end
