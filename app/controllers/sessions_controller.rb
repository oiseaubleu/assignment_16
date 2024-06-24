class SessionsController < ApplicationController
  # skip_before_action :login_required, only: %i[new create]

  def new
  end

  # def create
  #   user = User.find_by(email: params[:session][:email].downcase)
  #   if user&.authenticate(params[:session][:password])
  #     flash[:info] = 'ログインしました'
  #     log_in(user)
  #     redirect_to tasks_path(user.id)
  #   else
  #     flash.now[:danger] = 'メールアドレスまたはパスワードに誤りがあります'
  #     render :new
  #   end
  # end

  # def destroy
  #   session.delete(:user_id)
  #   flash[:info] = 'ログアウトしました'
  #   redirect_to new_session_path
  # end
end
