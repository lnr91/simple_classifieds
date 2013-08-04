class User < ActiveRecord::Base
  attr_accessible :email, :password, :password_confirmation, :old_password
  has_secure_password #have changed source code of this ... got latest version from master branch github ....secure_password.rb
                      # have also removed validations for password presence and the before_create callback to check for password_digest
  attr_accessor :impulse_signup, :old_password, :password_reset, :omniauth_signup
  validates :old_password, presence: true, on: :update, if: :validate_old_password? # The password_reset is when user forgot password and so he doesnt remember old password ...we set this to true in password_resets#update
  validates :password, presence: true, on: :create, unless: :dont_validate_password? # When we create a user through abnormal signup ...such as when a non user posts a new ad or replies to and , then we set the impulse_signup to true ...so that it skips the password validations
  validates :password, length: {minimum: 6}, if: lambda { |m| m.password.present? } # we have used the block, otherwise it validates for password even when params doesnt contain password
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
  validates :email, presence: true, uniqueness: {case_sensitive: false}
  before_create :create_remember_token
  before_create :create_email_activation_token
  before_save { self.email.downcase! }

  has_many :classifieds, dependent: :destroy
  has_many :received_messages, foreign_key: :to_id, class_name: 'Message'
  has_many :sent_messages, foreign_key: :from_id, class_name: 'Message'
  has_many :authentications, dependent: :destroy

  scope :active, where(email_activated: true)
  scope :inactive, where(email_activated: false)
  scope :with_password, where(has_password: true)
  scope :without_password, where(has_password: false)


  def send_password_reset
    create_password_reset_token
    self.password_reset_sent_at= Time.zone.now
    save!(validate: false)
    UserMailer.password_reset(self).deliver
  end

  def self.create_from_hash!(auth)
    user =new(email: auth.info.email)
    user.omniauth_signup = true
    user.has_password = false
    user.save
    Rails.logger.debug 'i am in user create_from_hash'
    user.errors.full_messages.each do |e|
      Rails.logger.debug  e
    end
    user
  end


  private
  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64 # If u just say remember_token= ...   then local variable
                                                      # remember_token is created...If u want to access table column
                                                      #remember_token...u need to use self.remember_token...
  end

  def create_email_activation_token
    self.email_activation_token = SecureRandom.urlsafe_base64
  end

  #Method determines whether password should be validated or not ...useful specially when u want to update email without password
  def dont_validate_password?
    impulse_signup || omniauth_signup
  end

  def validate_old_password?
    return false if password_reset
    has_password
  end

  def create_password_reset_token
    self.password_reset_token=SecureRandom.urlsafe_base64
  end

end
