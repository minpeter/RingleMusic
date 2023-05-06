class UsersController < ApplicationController
  def new
    @user = User.new
  end

  # signup
  def create
    @user = User.new(user_params)

    if @user.save
      # 회원가입이 성공하면 로그인 페이지로 이동합니다.
      redirect_to login_path, notice: '회원가입이 성공하였습니다. 로그인 해주세요.'
    else
      redirect_to signup_path, alert: '회원가입이 실패하였습니다. 다시 시도해주세요.'
    end
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
