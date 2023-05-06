class UsersController < ApplicationController
  def new
    @user = User.new
  end

  # signup
  def create
    @user = User.new(user_params)

   
    if !valid_email?(@user.email)
      redirect_to signup_path, alert: '이메일 주소가 올바르지 않습니다.'
    elsif !password_complexity(@user.password)
      redirect_to signup_path, alert: '비밀번호가 올바르지 않습니다.'
    elsif @user.save
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

    def valid_email?(email)
      # 이메일 주소 유효성 검사를 위한 정규식
      regex = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
    
      # 이메일 주소가 정규식에 일치하면 true 반환
      (email =~ regex) == 0
    end

    def password_complexity(password)
      # 비밀번호가 nil일 경우 검사하지 않음
      return true if password.nil?
    
      # 최소 8자, 최소 하나의 문자 및 하나의 숫자
      regex = /^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$/x
      password.match?(regex)
    end
end
