module Utilities
  def log_in(user)
    visit signin_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Sign in'
    #Sign in when not using Capybara as well....page 469..This is necessary when using one of the HTTP request methods directly
    cookies[:remember_token] = user.remember_token
  end

  def create_impulse_signup(email)
    @user = User.new(email: email)
    @user.has_password= false
    @user.impulse_signup= true # so that it skips password validations while creating a new user
    if @user.save()
      UserMailer.confirm_signup(@user).deliver
      @user
    end
  end

end