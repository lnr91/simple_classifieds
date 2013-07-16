class SessionsController < ApplicationController
  def create
    user = User.with_password.find_by_email(params[:session][:email])
    if user && user.authenticate(params[:session][:password])
      sign_in user
      redirect_to root_path
    elsif user = User.without_password.inactive.find_by_email(params[:session][:email])
      flash[:error]= 'Please confirm your email by clicking on the link we sent you'
      redirect_to root_path
      UserMailer.confirm_signup(user).deliver
    elsif user = User.without_password.find_by_email(params[:session][:email])
      flash[:error] = 'You have not set a password for your acccount. Please click the link which we sent you to set your password'
      redirect_to root_path
      UserMailer.set_password(user).deliver
    else
      flash.now[:error]= "Invalid email/password"
      render 'new'
    end

  end

  def destroy
    sign_out
    redirect_to root_path
  end
end
