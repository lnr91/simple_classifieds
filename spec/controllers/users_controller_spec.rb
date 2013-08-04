require 'spec_helper'
include Utilities
describe UsersController do
  let(:user) { Factory(:user) }
  let(:admin) { Factory(:admin) }
  let(:other_user) { Factory(:user) }

  describe 'users#index' do
    before { @user1 = Factory(:user) }
    context 'user is Admin' do
      before do
        log_in admin
      end
      it 'should get list of all users' do
        get :index
        assigns(:users).should eq([@user1, admin])
      end
    end
    context 'user is not Admin' do
      before do
        log_in user
        get :index
      end
      it 'should not get list of users' do
        assigns(:users).should_not eq([@user1, user])
      end
      it 'should redirect to root path' do
        response.should redirect_to root_path
      end
    end

  end
  describe 'users#new' do
    context 'signed in user' do
      before do
        log_in user
        get :new
      end
      it 'should redirect to root path' do
        response.should redirect_to root_path
      end
    end
    context 'non signed in user' do
      before { get :new }
      it 'should assign a new user' do
        assigns(:user).should be_an_instance_of User
      end

    end

  end
  describe 'users#show' do
    context 'when user is not admin' do
      before { log_in user }
      describe 'users own profile' do
        before { get :show, id: user }
        it 'should load users profile' do
          assigns(:user).should eq(user)
        end
      end
      describe 'other peoples profile' do
        before { get :show, id: other_user }
        it 'should redirect to root path' do
          response.should redirect_to root_path
        end
      end

    end
    context 'when user is admin' do
      before { log_in admin }
      describe 'users own profile' do
        before { get :show, id: admin }
        it 'should load users profile' do
          assigns(:user).should eq(admin)
        end
      end
      describe 'other peoples profile' do
        before { get :show, id: other_user }
        it 'should redirect to root path' do
          assigns(:user).should eq(other_user)
        end
      end

    end


  end
  describe 'users#create' do
    context 'with valid attributes' do
      before { User.any_instance.stub(:valid?).and_return(true) }
      it 'creates a new contact' do
        expect do
          post :create, user: Factory.attributes_for(:user)
        end.to change(User, :count).by(1)
      end
      it 'redirects to root path' do
        post :create, user: Factory.attributes_for(:user)
        response.should redirect_to root_path
      end
      it 'should send a welcome mailer' do
        message = mock('Message')
        message.stub(:deliver).and_return true
        user_attributes = Factory.attributes_for :user
        mock_user= mock(User)
        mock_user.stub(:remember_token)
        User.should_receive(:new).with(user_attributes.stringify_keys!).and_return(mock_user)
        mock_user.should_receive(:save).and_return(true)
        UserMailer.should_receive(:confirm_signup).with(mock_user).and_return(message)
        message.should_receive :deliver
        post :create, user: user_attributes
      end
    end
    context 'with invalid attributes' do
      before { User.any_instance.stub(:valid?).and_return(false) }
      it 'doesnt create a new contact' do
        expect do
          post :create, user: Factory.attributes_for(:user)
        end.to change(User, :count).by(0)
      end
      it 'renders the signup page' do
        post :create, user: Factory.attributes_for(:user)
        response.should render_template 'new'
      end

    end
  end
  describe 'users#update_other_fields' do
    context 'when not signed in' do
      before { put :update_other_fields, id: user, email: 'newq@gmail.com' }
      specify { response.should redirect_to signin_path }
      it 'should not update user attributes' do
        user.reload
        user.email.should_not eq('newq@gmail.com')
      end
    end
    context 'when signed in' do
      before do
        log_in user
      end
      context 'updating of same user' do
        describe 'with correct password' do
          describe 'with valid attributes' do
            before do
              put :update_other_fields, id: user, user: {old_password: user.password, email: 'newemail@gmail.com'}
            end
            it 'should load user in @user' do
              assigns(:user).should eq(user)
            end
            it 'should update user attributes' do
              user.reload
              user.email.should eq('newemail@gmail.com')
            end
            it 'should redirect to updated user account page' do
              response.should redirect_to user_path user
            end
          end
          describe 'with invalid attributes' do
            before do
              put :update_other_fields, id: user, user: {old_password: user.password, email: 'newemailasd'}
            end
            it 'should re render the edit page' do
              response.should render_template 'edit'
            end
            it 'should not update user attributes' do
              user.reload
              user.email.should_not eq('newemailasd')
            end
          end
        end
        describe 'with invalid password' do
          before { put :update_other_fields, id: user, user: {old_password: 'pssweeeddd', email: 'newemail@gmail.com'} }
          it 'should re render the edit page' do
            response.should render_template 'edit'
          end
          it 'should not update user attributes' do
            user.reload
            user.email.should_not eq('newemail@gmail.com')
          end
        end
        describe 'when user has password not set' do
          before do
            user.has_password= false
            user.impulse_signup= true # so that it skips password validations while creating a new user
            user.save!
          end
          before { put :update_other_fields, id: user, email: 'newemail@gmail.com' }
          specify { response.should render_template 'form_new_password' }
          it 'should not update attributes' do
            user.reload
            user.email.should_not eq('newemail@gmail.com')
          end

        end
      end
      context 'updating of another user account' do
        before do
          put :update_other_fields, id: other_user, user: {old_password: other_user.password, email: 'newemail@gmail.com'}
        end
        it 'should not update user attributes' do
          other_user.reload
          other_user.email.should_not eq('newemail@gmail.com')
        end
        specify { response.should redirect_to root_path }
      end
    end
  end
  describe 'Users#update_password' do
    context 'when not signed in' do
      before { put :update_password, id: user, password: 'password', password_confirmation: 'password' }
      specify { response.should redirect_to signin_path }
    end
    context 'when signed in' do
      describe 'impulse user password not set' do
        before do
          @impulse_user = create_impulse_signup 'impulse_user@gmail.com'
          log_in @impulse_user
          put :update_password, id: @impulse_user, user: {password: 'password', password_confirmation: 'password'}
        end
        it 'should load user in @user' do
          assigns(:user).should eq(@impulse_user)
        end
        it 'should update user attributes' do
          @impulse_user.reload
          @impulse_user.password_digest.should_not be_nil
        end
        it 'should redirect to user account page' do
          response.should redirect_to user_path @impulse_user
        end
      end
    end
  end
end
