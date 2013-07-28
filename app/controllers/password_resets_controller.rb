class PasswordResetsController < ApplicationController

  def create
    user = User.find_by_email(params[:email])
    user.send_password_reset
    redirect_to signin_path, notice: "Email sent with password reset instructions"
  end

  def new

  end

  def edit
    @user = User.find_by_password_reset_token(params[:id])
  end

  def update
    @user = User.find_by_password_reset_token(params[:id])
    @user.password_reset= true
    if @user.update_attributes(params[:user])
      redirect_to signin_path, notice: 'Your password has been changed'
    else
      render :edit
    end
  end


end
