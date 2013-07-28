class UsersController < ApplicationController
  # GET /users
  # GET /users.json
  before_filter :signed_in_user, only: [:edit, :destroy, :update_password, :show, :index, :update_other_fields]
  before_filter(only: [:edit, :destroy, :update_password, :update_other_fields, :show]) { |c| c.correct_user params[:id] } # Use block form ....This is the way to send parameters to method used in
  before_filter :is_admin_user, only: [:index]
  before_filter :redirect_unless_password_set, only: [:edit, :update_other_fields]
  before_filter :not_signed_in_user, only: [:new]

  def index
    @users = User.all
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit

  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])
    respond_to do |format|
      if @user.save
        UserMailer.confirm_signup(@user).deliver
        sign_in @user
        format.html { redirect_to root_path, notice: 'User successfully created' }
      else
        format.html { render action: 'new' }
      end
    end
  end


  def update_other_fields
    user = get_user_with_password params[:user][:old_password] # here user is just fr authenticating user with old password while updating...see the method to knw more
    if user and @user.update_attributes(params[:user])
      flash[:notice]= 'User was successfully updated.'
      respond_to do |format|
        format.html { redirect_to @user }
        format.js { render js: "window.location='#{user_path @user}'" }
      end
    else
      respond_to do |format|
        format.html { render template: 'users/edit', locals: {user: @user} }
        format.js { render 'update_error' }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update_password
    user = get_user_with_password params[:user][:old_password]
    if user and @user.update_attributes(params[:user])
      @user.update_attribute(:has_password, true) if (:password_not_set and !params[:user][:password].blank?) # for users who are setting password for first time... for others it is already true...also 2nd condition in 'if' is to check whether user has set a password or simply pressed button without updating password
      flash[:notice]= 'User was successfully updated.'
      sign_in @user # Here we sign in user again ...because we have a before_save callback that creates a new remember_token on saving...this doesnt math the token present in browser cookies...so u have to log in again

      respond_to do |format|
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.js { render js: "window.location='#{user_path @user}'" }
        format.json { head :no_content }
      end
    else
      @user.errors.full_messages.each do |e|
        raise e.to_s
      end
      respond_to do |format|
        format.html { render template: 'users/form_new_password', locals: {user: @user} }
        format.json { render json: @user.errors, status: :unprocessable_entity }
        format.js { render 'update_error' }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_path, notice: 'User destroyed' }
      format.json { head :no_content }
    end
  end


  def activate_email
    unless @user=User.find_by_email_activation_token(params[:email_activation_token])
      flash[:failure]= 'Invalid email activation'
      redirect_to root_path
      return
    end
    if @user.email_activated
      message = 'Please set your password if you wish to access account directly'
    else
      @user.update_attribute(:email_activated, true)
      message = 'Your email has been activated. Please set your password if you wish to access account directly'
    end
    sign_in @user
    unless @user.has_password
      flash[:notice] = message
      #redirect_to edit_user_path @user, password_not_set: true
      render template: 'users/form_new_password', locals: {user: @user}
      return
    end
    flash[:notice]= 'Your email has been activated'

    redirect_to @user
  end


end
