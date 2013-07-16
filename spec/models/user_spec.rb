require 'spec_helper'

describe User do
  before {@user = User.new(email:'user1@gmail.com',password:'password',password_confirmation:'password')}
  subject {@user}
  it {should respond_to(:email)}
  it {should respond_to(:password_digest)}
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:remember_token) }
  it {should be_valid}
  it {should respond_to(:admin)}
  it {should respond_to(:authenticate) }
  it {should_not be_admin }
  it {should respond_to(:classifieds)}
  describe "when email is not present" do
    before { @user.email = " " }
    it { should_not be_valid }
  end
  describe "When email is already taken" do
    before do
      user_with_same_email =@user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end
    it { should_not be_valid}
  end
  describe "when password is not present" do
    before { @user.password = @user.password_confirmation = " " }
    it { should_not be_valid }
  end
  describe "when password doesn't match confirmation" do
    before { @user.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end
  describe "when password confirmation is nil" do
    before { @user.password_confirmation = nil }
    it { should_not be_valid }
  end

  describe "with a password that's too short" do
    before { @user.password = @user.password_confirmation = "a" * 5 }
    it { should be_invalid }
  end
  describe "email address with mixed case" do
    let(:mixed_case_email) { "Foo@ExAMPle.CoM" }
    it "should be saved as all lower-case" do
      @user.email = mixed_case_email
      @user.save
      @user.reload.email.should == mixed_case_email.downcase
    end
  end
  describe "remember token" do
    before {@user.save}
    its(:remember_token) {should_not be_blank} # that is equivalent to it {@user.remember_token.should_not be_blank}
  end
  describe "with admin attribute set to true" do
    before do
      @user.save!
      @user.toggle!(:admin)
    end
    it {should be_admin}
  end
  describe "accessible attributes" do
    it "admin attribute must not be accessible for mass assignment" do
      expect do
        User.new(admin: true)
      end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end



end
