require Rails.root.join('lib', 'json_web_token')

class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email])
    

    if user && user.authenticate(params[:password])
      token = JsonWebToken.encode(user_id: user.id)
      # 쿠키대신 세션에 jwt_token을 저장합니다.
      session[:jwt_token] = token
      redirect_to root_path, notice: "로그인 되었습니다."
    else
      redirect_to login_path, alert: "이메일 또는 비밀번호가 올바르지 않습니다."
    end
  end

  # def destroy
  #   cookies.delete(:jwt)
  #   redirect_to root_path, notice: "로그아웃 되었습니다."
  # end
end
