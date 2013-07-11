class Classified < ActiveRecord::Base
  attr_accessible :category_id, :description, :name, :price
  belongs_to :subcategory,class_name:'Category'
  belongs_to :category,class_name: 'Category'
  belongs_to :user

end
