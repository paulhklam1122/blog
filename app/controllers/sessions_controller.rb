class SessionsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.find_by_email params[:email]
    if @user.account_lockout == false
      if @user && @user.authenticate(params[:password])
        sign_in(@user)
        redirect_to root_path, notice: "Signed In!"
      else
        flash[:alert] = "Wrong Credentials!"
        @user.increment_login_lockout_count
        render :new
      end
    else
      redirect_to root_path, notice: "You have entered wrong credientials too many times! Go reset your password!"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: "Signed Out!"
  end
end
