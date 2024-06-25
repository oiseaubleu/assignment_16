module SessionsHelper
  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  # ユーザがログイン中かどうかを判断するメソッド
  def logged_in?
    current_user.present?
  end

  # ログイン状態にするメソッド
  def log_in(user)
    session[:user_id] = user.id
  end

  def current_user?(user)
    user == current_user
  end
end