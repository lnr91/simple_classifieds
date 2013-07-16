class UsersController < ApplicationController
  # GET /users
  # GET /users.json
  before_filter :signed_in_user, only: [:edit, :destroy, :update, :show, :index]
  before_filter(only: [:edit, :destroy, :update, :show]) { |c| c.correct_user params[:id] } # Use block form ....This is the way to send parameters to method used in


  before_filter :is_admin_user, only: [:index]

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
    @user.has_password=true
    respond_to do |format|
      if @user.save
        UserMailer.confirm_signup(@user).deliver
        format.html { redirect_to signin_path, notice: 'User was successfully created.' }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: 'new' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update


    respond_to do |format|
      if @user.update_attributes(params[:user])
        @user.update_attribute(:has_password, true) if :password_not_set # for users who are setting password for first time... for others it is already true
        sign_in @user # Here we sign in user again ...because we have a before_save callback that creates a new remember_token on saving...this doesnt math the token present in browser cookies...so u have to log in again
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
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
      redirect_to edit_user_path @user, password_not_set: true
      return
    end
    flash[:notice]= 'Your email has been activated'

    redirect_to @user
  end

end
