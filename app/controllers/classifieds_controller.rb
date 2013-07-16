class ClassifiedsController < ApplicationController
  # GET /classifieds
  # GET /classifieds.json
  before_filter :signed_in_user, only: [:edit, :destroy, :update]
  before_filter(only: [:edit, :destroy, :update]) do |c|
    user_id = Classified.find_by_id(params[:id]).user_id
    c.correct_user user_id # Use block form ....This is the way to send parameters to method used in
  end

  def index
    @classifieds = Classified.all
    respond_to do |format|
      format.html do
        if !signed_in? || !is_admin?
          render 'index'
        else
          render 'admin/classifieds/index'
        end

      end
      format.json { render json: @classifieds }
    end
  end

  # GET /classifieds/1
  # GET /classifieds/1.json
  def show
    @classified = Classified.find(params[:id])
    @message = @classified.messages.build # In this case ..its same as Message.new ....because while building an empty message , since this message is not nested in some routes like  users/12/messages ....so when u do form_for @message ....it doesnt matter much...the only advantage of building through association a new record (not creating mind u ...building) is that when u do form_for @message ...it auto.. gets the route path of the message

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @classified }
    end
  end

  # GET /classifieds/new
  # GET /classifieds/new.json
  def new
    @classified = Classified.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @classified }
    end
  end

  # GET /classifieds/1/edit
  def edit
    @classified = @user.classifieds.find(params[:id])
  end

  # POST /classifieds
  # POST /classifieds.json
  def create
    if signed_in?
      @classified = current_user.classifieds.build(params[:classified])
    else
      if user_present?(params[:email])   # checks whether user is already present ...and if present assigns it to @user
        redirect_to signin_path, notice: 'This account is already in use.Please sign in to use it'
        return
      else
        create_impulse_signup params[:email]
      end
      @classified = @user.classifieds.build(params[:classified])
    end
    respond_to do |format|
      if @classified.save
        if signed_in?
          format.html { redirect_to @classified, notice: 'Classified was successfully created.' }
        else
          format.html { redirect_to @classified, notice: 'Classified was successfully created..Please confirm your email account by clicking on the link we sent you' }
        end
        format.json { render json: @classified, status: :created, location: @classified }
      else
        format.html { render action: 'new' }
        format.json { render json: @classified.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /classifieds/1
  # PUT /classifieds/1.json
  def update
    @classified = @user.classifieds.find(params[:id])

    respond_to do |format|
      if @classified.update_attributes(params[:classified])
        format.html { redirect_to @classified, notice: 'Classified was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @classified.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /classifieds/1
  # DELETE /classifieds/1.json
  def destroy
    @classified = @user.classifieds.find(params[:id])
    @classified.destroy

    respond_to do |format|
      format.html { redirect_to classifieds_url }
      format.json { head :no_content }
    end
  end

  private



end
