describe 'UserPages' do

  subject { page }
  describe 'Signup Page' do
    before { visit new_user_path }
    it { should have_selector('title', text: 'Railsifieds - Sign up') }
    it { should have_selector('h2', text: 'Sign up') }
  end
  describe 'Signup' do
    before { visit new_user_path }
    let(:submit) { 'Sign up' }
    describe 'with invalid information' do
      it 'should not create a new user' do
        expect do
          click_button :submit
        end.not_to change(User, :count)
      end
    end

    describe 'with valid information' do
      before do
        fill_in 'Email', with: 'example@gmail.com'
        fill_in 'Password', with: 'password'
        fill_in 'Password confirmation', with: 'password'
      end
      it 'should increase user count by 1' do
        expect do
          click_button :submit
        end.to change(User, :count).by(1)
      end
      describe 'after saving the user' do
        before { click_button :submit }
        let(:user) { User.find_by_email('example@gmail.com') }
        it { should have_link(user.email) }
        it { should have_link('Sign out') }
        it { should have_selector('div.alert.alert-success') }
      end
    end
  end
  describe 'editing user account' do
    let(:user) { Factory(:user) }
    before do
      log_in user
      visit edit_user_path(user)
    end
    it { should have_selector('h3', text: 'Account Settings') }
    it { should have_link('Change Password') }



  end
end