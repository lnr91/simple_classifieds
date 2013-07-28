class UserMailer < ActionMailer::Base

  default from: 'droidreddyhyd@gmail.com'

  def confirm_signup(user)
    @user = user
    mail(to: user.email, subject: 'Confirm Email')
  end

  def confirm_email_change
    #TODO this hasnt been implemented in controller or model...should i add a observer for this.. or a custom action in users controller like update_email...lets see
    @user = user
    mail(to: user.email, subject: 'Confirm Email Change')
  end

  def set_password(user)
    @user = user
    mail(to: user.email, subject: 'Please set your password')
  end

  def send_message(message)
    @message= message
    mail(to: @message.receiver.email, subject: 'You have a message')
  end

  def password_reset user
    @user = user
    mail(to:user.email,subject:'Reset your password')
  end

end
