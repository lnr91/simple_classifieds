class User < ActiveRecord::Base
  attr_accessible :email, :password, :password_confirmation
  has_secure_password
  validates_presence_of :password
  validates :email, presence: true, uniqueness: {case_sensitive: false}
  before_save :create_remember_token
  before_create :create_email_activation_token
  has_many :classifieds, dependent: :destroy
  scope :active ,where(email_activated: true)


  private
  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64 # If u just say remember_token= ...   then local variable
                                                      # remember_token is created...If u want to access table column
                                                      #remember_token...u need to use self.remember_token...
  end

  def create_email_activation_token
    self.email_activation_token = SecureRandom.urlsafe_base64
  end

end
