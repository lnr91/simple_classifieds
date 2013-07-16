class Classified < ActiveRecord::Base
  attr_accessible :category_id, :description, :name, :price
  validates :name, presence:true
  validates :description, presence:true
  validates :user, presence:true
  validates :category, presence: true
  belongs_to :subcategory,class_name:'Category'
  belongs_to :category,class_name: 'Category'
  belongs_to :user
  has_many :messages , dependent: :destroy

end
