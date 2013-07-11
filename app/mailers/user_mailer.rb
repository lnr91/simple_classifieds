class UserMailer < ActionMailer::Base

  default from:'droidreddyhyd@gmail.com'

def confirm_signup(user)
  @user = user
  mail(to:user.email,subject:'Confirm Email')
end

end
