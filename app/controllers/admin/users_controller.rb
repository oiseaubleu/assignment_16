class Admin::UsersController < ApplicationController
  # before_action :set_admin, only: %i[show edit update destroy]
  before_action :correct_admin # , only: %i[show edit update destroy]
  before_action :set_user, only: %i[show edit update destroy]
  skip_before_action :login_required, only: %i[new create]
  # OK
  def index
    @users = User.all.includes(:tasks)
  end

  # OK
  def show
    @user = User.find(params[:id])
  end

  # OK
  def new
    @user = User.new
  end

  # OK
  def edit
  end

  # OK
  def create
    @user = User.new(user_params)

    if @user.save
      flash[:info] = 'ユーザを登録しました'
      redirect_to admin_users_path
    else
      render :new
    end
  end

  def update
    if @user.update(user_params)
      flash[:info] = 'ユーザを更新しました'
      redirect_to admin_users_path
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:info] = 'ユーザを削除しました'
      redirect_to admin_users_url
    else
      # binding.irb
      # flash[:info] = 'ユーザを削除してないです！'
      @users = User.all.includes(:tasks)
      response.headers['Location'] = admin_users_path
      render :index
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :admin)
  end

  def correct_admin
    # redirect_to current_user unless current_user?(@user)
    # if current_user.admin?
    #   @user = User.find(params[:id])
    # else
    # binding.irb
    return if current_user.admin?

    flash[:danger] = '管理者以外アクセスできません'
    redirect_to tasks_path(current_user.id)
  end
end
