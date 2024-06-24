class UsersController < ApplicationController
  before_action :correct_user, only: %i[show edit update destroy]
  # skip_before_action :login_required, only: %i[new create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      # ユーザ登録に成功した場合の処理
      flash[:info] = 'アカウントを登録しました'
      # log_in(@user)
      # redirect_to tasks_path(@user.id)
      redirect_to user_path(@user.id)
    else
      # ユーザ登録に失敗した場合の処理
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
  end

  # #編集==============
  def edit
  end

  # #更新==============
  def update
    # binding.irb
    if @user.update(user_params)
      redirect_to user_path(@user.id), notice: '	アカウントを更新しました'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to current_user unless current_user?(@user)
  end
end
