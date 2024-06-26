class UsersController < ApplicationController
  before_action :correct_user, only: %i[show edit update destroy]
  skip_before_action :login_required, only: %i[new create]
  # skip_before_action :correct_admin

  def new
    if logged_in? == false
      @user = User.new
    else
      flash[:info] = 'ログアウトしてください'
      redirect_to tasks_path(current_user.id)
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      # if current_user.admin?
      #   flash[:info] = 'ユーザを登録しました'
      #   redirect_to admin_users_path
      # else
      #   flash[:info] = 'アカウントを登録しました'
      #   log_in(@user)
      #   redirect_to tasks_path(@user.id)
      # end

      # ユーザ登録に成功した場合の処理
      flash[:info] = 'アカウントを登録しました'
      log_in(@user)
      redirect_to tasks_path(@user.id)

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
      # redirect_to user_path(@user.id), notice: '	アカウントを更新しました'
    else
      render :edit # , status: :unprocessable_entity
    end
  end

  # #削除==============
  def destroy
    @user.destroy
    redirect_to admin_users_path
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def correct_user
    @user = User.find(params[:id])
    # redirect_to current_user unless current_user?(@user)
    return if current_user?(@user)

    # flash.now[:danger] = 'アクセス権限がありません'
    flash[:info] = 'アクセス権限がありません'
    redirect_to tasks_path(current_user.id) # , notice: 'アクセス権限がありません'
  end
end
