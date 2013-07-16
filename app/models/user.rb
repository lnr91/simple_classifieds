class User < ActiveRecord::Base
  attr_accessible :email, :password, :password_confirmation
  has_secure_password    #have changed source code of this ... got latest version from master branch github ....secure_password.rb
                         # have also removed validations for password presence and the before_create callback to check for password_digest
  attr_accessor :impulse_signup
  validates :password,presence:true,length: {minimum: 6}, unless: :impulse_signup    # When we create a user through abnormal signup ...such as when a non user posts a new ad or replies to and , then we set the impulse_signup to true ...so that it skips the password validations
  validates :password_confirmation,presence:true,if: lambda { |m| m.password.present? }
  validates :email, presence: true, uniqueness: {case_sensitive: false}
  before_create :create_remember_token
  before_create :create_email_activation_token

  before_save { self.email.downcase! }
  has_many :classifieds, dependent: :destroy
  has_many :received_messages,foreign_key: :to_id,class_name: 'Message'
  has_many :sent_messages,foreign_key: :from_id, class_name: 'Message'
  scope :active ,where(email_activated: true)
  scope :inactive ,where(email_activated: false)
  scope :with_password, where(has_password: true)
  scope :without_password, where(has_password: false)


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
