module UsersHelper

  def create_impulse_signup(email)
    @user = User.new(email: email)
    @user.has_password= false
    @user.impulse_signup= true # so that it skips password validations while creating a new user
    if @user.save()
      UserMailer.confirm_signup(@user).deliver
    end
  end


  def user_present? email
    @user = User.find_by_email(email)
  end


  def get_user_with_password password
    if @user.has_password?
      flash.now[:error]='Please enter correct password' unless user = User.find_by_email(current_user.email).try(:authenticate, password)
      user
    else
      user = @user    # This is for cases where new impulse user has not set the password
    end
  end

  def redirect_unless_password_set
    unless @user.has_password?
      render template: 'users/form_new_password', locals: {user: @user}
    end
  end


end
