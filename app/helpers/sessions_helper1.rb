module SessionsHelper1

  def sign_in user
    cookies.permanent[:remember_token] = user.remember_token
    self.current_user= user
  end


  def current_user=(user)
    @current_user=user
  end

  def current_user
    @current_user ||= User.find_by_remember_token(cookies[:remember_token])
  end

  def signed_in?
    !current_user.nil?
  end

  def sign_out
    cookies.delete(:remember_token)
    self.current_user = nil
  end

  def signed_in_user
    redirect_to signin_path, notice: 'Please sign in' unless signed_in?
  end

=begin
  # In context of editing and destroying a classified
  def correct_user_classified
    @classified = Classified.find_by_id(params[:id])
    if signed_in?
      if @classified.user.email != current_user.email
        redirect_to signin_path, notice: "Please sign in as #{@classified.user.email}  to edit this ad"
      end
    end
    if !signed_in?
      if User.where(email: @classified.user.email, email_activated: true).present?
        redirect_to signin_path, notice: "Please sign in as #{@classified.user.email}  to edit this ad"
      end
    end

  end
=end

  #In context of editing and destroying a user ...this is diffeerent fron correct_user_classified ...but the intent is same...to see that the resource being destroyed belongs to the person destroying it.
  def correct_user(id)
   @user= User.find_by_id(id)
   redirect_to root_path unless current_user == @user || current_user.admin?
  end

  def is_admin?
    current_user.admin
  end

  def is_admin_user
    redirect_to root_path unless is_admin?
  end


end
