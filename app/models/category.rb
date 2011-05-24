class Category < ActiveRecord::Base

  acts_as_nested_set  
  has_many :categorizations
  has_many :studies , :through => :categorizations
end