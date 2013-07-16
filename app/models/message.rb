class Message < ActiveRecord::Base
  belongs_to :classified
  belongs_to :sender, foreign_key: :from_id ,class_name: 'User'
  belongs_to :receiver, foreign_key: :to_id ,class_name: 'User'
  attr_accessible :content, :from_id, :to_id
  validates :content, presence:true
  validates :from_id,:to_id, presence:true
  validates :classified, presence: true

end
