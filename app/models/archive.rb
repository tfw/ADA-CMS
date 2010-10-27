class Archive < ActiveRecord::Base
  acts_as_inkling 'Archive'
  
  validates_presence_of :name
  validates_uniqueness_of :name
  
  has_many :pages
end