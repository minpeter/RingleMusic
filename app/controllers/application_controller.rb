require Rails.root.join('lib', 'json_web_token')

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_user

  private

  def current_user
    if session[:jwt_token]
      # jwt_token이 존재할 경우 디코딩하여 user를 찾는다.
      decoded_token = JsonWebToken.decode(session[:jwt_token])
      user_id = decoded_token[:user_id]
      @current_user = User.find_by(id: user_id)
    else
      # jwt_token이 존재하지 않을 경우 @current_user를 nil로 설정한다.
      @current_user = nil
    end
  end
end
