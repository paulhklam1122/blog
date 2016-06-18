class PasswordResetsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.find_by_email params[:email]
    if @user
      token = reset_token
      @user.update password_reset_token: token
      render text: edit_password_reset_path(@user) + "/?token=#{token}"
      #email sent to the email address
      # flash[:notice] = "Email has been sent"
      # redirect_to root_path
    else
      flash[:alert] = "Email is not found"
      redirect_to new_password_reset_path
    end
  end

  def edit
    @user = User.find_by_password_reset_token params[:password_reset_token]
  end

  def update
    @user = User.find_by_password_reset_token params[:password_reset_token]
    user_params = params.permit(:password, :password_confirmation)
    if @user.update user_params
      redirect_to root_path, notice: "Information updated!"
    else
      redirect_to edit_user_path(@user), notice: "aaa"
    end
  end

  def reset_token
    SecureRandom.urlsafe_base64
  end
end
