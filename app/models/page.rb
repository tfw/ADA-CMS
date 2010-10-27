class Page < ActiveRecord::Base
  acts_as_inkling 'Page'
  
  belongs_to :archive
end