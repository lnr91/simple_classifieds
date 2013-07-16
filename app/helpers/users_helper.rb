module UsersHelper

  def create_impulse_signup(email)
    @user = User.new(email: email)
    @user.impulse_signup= true # so that it skips password validations while creating a new user
    if @user.save()
      UserMailer.confirm_signup(@user).deliver
    end
  end


  def user_present? email
    @user = User.find_by_email(email)
  end

end
