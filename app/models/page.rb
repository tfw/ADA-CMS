class Page < ActiveRecord::Base
  acts_as_inkling 'Page'
  
  belongs_to :archive
  belongs_to :author, :class_name => "Inkling::User", :foreign_key => "user_id"
  belongs_to :parent, :class_name => "Page"
  has_many :children, :class_name => "Page", :foreign_key => "parent_id"
  
  before_validation :link_title_defaults_to_title
  before_validation :default_partial, :if => "self.partial.nil?"

  validate :unique_archive_and_link_combination, :if => "self.archive"
  validates_presence_of :author
  validates_presence_of :link_title
  validates_presence_of :partial
  
    
  def unique_archive_and_link_combination
    pre_existing = Page.find_all_by_archive_id_and_title(self.archive.id, self.title)
    
    return if pre_existing.size == 0
    return if pre_existing.size == 1 and pre_existing[0].id == self.id 

    errors.add(:name, "There's a page already named #{self.title} in the #{self.archive.name} archive.") if pre_existing and self.archive
    errors.add(:archive, "There's a page already named #{self.title} in the #{self.archive.name} archive.")  if pre_existing and self.archive
  end
  
  def link_title_defaults_to_title
    if self.link_title.nil?
      self.link_title = title
    end
  end
  
  def default_partial
    self.partial = "/pages/default_page"
  end
end


