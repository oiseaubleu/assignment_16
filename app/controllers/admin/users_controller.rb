class Admin::UsersController < ApplicationController
  # before_action :set_admin, only: %i[show edit update destroy]
  before_action :correct_user, only: %i[show edit update destroy]
  skip_before_action :login_required, only: %i[new create]
  # OK
  def index
    @users = User.all
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
      redirect_to admin_user_path(@user), notice: 'admin was successfully created.'
    else
      render :new
    end
  end

  def update
    if @user.update(user_params)
      redirect_to admin_user_path(@user), notice: 'admin was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @admin.destroy
    redirect_to admin_users_url, notice: 'admin was successfully destroyed.'
  end

  private

  # def set_admin
  #   @admin = Admin.find(params[:id])
  # end
  def correct_user
    @user = User.find(params[:id])
    # redirect_to current_user unless current_user?(@user)
    return if current_user?(@user)

    flash[:danger] = 'アクセス権限がありません'
    redirect_to tasks_path(current_user.id)
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :admin)
  end
end
