class UserMailer < ActionMailer::Base

  default from:'droidreddyhyd@gmail.com'

def confirm_signup(user)
  @user = user
  mail(to:user.email,subject:'Confirm Email')
end

def set_password(user)
  @user = user
  mail(to:user.email,subject:'Please set your password')
end

  def send_message(message)
     @message= message
    mail(to:@message.receiver.email,subject:'You have a message')
  end

end
