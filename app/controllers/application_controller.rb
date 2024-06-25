class ApplicationController < ActionController::Base
  include SessionsHelper
  before_action :login_required
  before_action :correct_admin

  private

  def login_required
    return if current_user

    flash[:danger] = 'ログインしてください'
    redirect_to new_session_path
  end

  def correct_admin
    # redirect_to current_user unless current_user?(@user)
    # if current_user.admin?
    #   @user = User.find(params[:id])
    # else
    return if current_user.admin?

    flash[:danger] = '管理者以外アクセスできません'
    redirect_to tasks_path(current_user.id)
  end
end
