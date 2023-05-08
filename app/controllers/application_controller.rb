class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_user

  private

  def current_user
    if session[:user_id].present?
      # session에 user_id가 존재할 경우, 해당 user_id를 이용해 @current_user를 설정한다.
      user_id = session[:user_id]
      @current_user = User.find_by(id: user_id)
    else
      # jwt_token이 존재하지 않을 경우 @current_user를 nil로 설정한다.
      @current_user = nil
    end
  end
end
