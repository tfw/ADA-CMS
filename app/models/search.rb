class Search < ActiveRecord::Base
  
  serialize :filters, Array
  
  belongs_to :user
  belongs_to :archive
  
  validate :unique_user_and_title
  validates_presence_of :user
  validates_presence_of :title
  # validates_presence_of :filters
  validates_presence_of :terms
  validates_presence_of :archive  
  # validates_uniqueness_of :query
  
  def unique_user_and_title
    pre_existing = Search.find_by_user_id_and_title(self.user, self.title)
  end
  
  # 
  # def to_param
  #   "saved-search-#{self.title}"
  # end
end
