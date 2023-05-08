class SessionsController < ApplicationController
  def new
  end


  def create
    if params[:email].present? && params[:password].present?
      user = User.find_by(email: params[:email])
      if user && user.authenticate(params[:password])
        session[:user_id] = user.id
        redirect_to root_path
        return
      else
        redirect_to login_path, alert: "이메일 또는 비밀번호가 올바르지 않습니다."
      end
    else
      redirect_to login_path, alert: "이메일 또는 비밀번호를 입력해주세요."
    end
  end

  def destroy
    reset_session
    redirect_to root_path
  end



end
