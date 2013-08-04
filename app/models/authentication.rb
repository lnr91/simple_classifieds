class Authentication < ActiveRecord::Base
  attr_accessible :provider, :uid, :user_id
  belongs_to :user
  validates_presence_of :user_id, :uid, :provider
  validates_uniqueness_of :uid, :scope => :provider


  def from_omniauth(auth)
    where(auth.slice(:provider, :uid)).first_or_initialize.tap do |auth_of_user|

    end
  end


  def self.find_from_hash(auth)
    find_by_provider_and_uid(auth.provider,auth.uid)
  end

  def self.create_from_hash(auth)
    Rails.logger.debug 'i am in create_from_hash of authentication'
    user = User.create_from_hash!(auth)
    Authentication.create(:user_id => user.id, :uid => auth.uid, :provider => auth.provider)
  end

end
