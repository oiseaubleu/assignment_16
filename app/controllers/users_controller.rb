class UsersController < ApplicationController
  # のちほどbeforeとskip入れるよ！！！！！

  def new
    @user = User.new
  end

  # #編集==============
  def edit
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
