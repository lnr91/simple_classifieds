class MessagesController < ApplicationController

  before_filter :signed_in_user, only: [:show_sent_messages, :show_received_messages]

  def create
    @classified = Classified.find(params[:message][:classified_id])
    if signed_in?
      @user = current_user
    else
      create_impulse_signup params[:email] unless user_present? params[:email] # creates user and assigns it to @user
    end

=begin
    from_id = @user.id      #This @user is returned by user_present? method if user exists...or create_impulse_signup method if a new user created now
    to_id = @classified.user.id
=end
    params.delete(:email)
    params[:message].delete(:classified_id)
    params[:message].merge!(from_id: @user.id, to_id: @classified.user.id)
    @message = @classified.messages.build(params[:message])
    if @message.save
      redirect_to :back, notice: 'Your message has been sent to the user' #This just redirects to current page..refreshes page  http://www.ryanonrails.com/2010/08/18/redirect-refresh-your-current-page/
      UserMailer.send_message(@message).deliver
    end
  end

  def show_sent_messages
    @messages = current_user.sent_messages
  end

  def show_received_messages
    @messages = current_user.received_messages
  end


end
