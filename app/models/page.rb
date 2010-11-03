class Page < ActiveRecord::Base
  acts_as_inkling 'Page'
  
  belongs_to :archive
  belongs_to :author, :class_name => "Inkling::User", :foreign_key => "user_id"
  belongs_to :parent, :class_name => "Page"
  has_many :children, :class_name => "Page", :foreign_key => "parent_id"
  
  validate :unique_archive_and_name_combination, :if => "self.archive"
  validates_presence_of :author_id
    
  def unique_archive_and_name_combination
    pre_existing = Page.find_by_archive_id_and_name(self.archive.id, self.name)
    errors.add(:name, "There's a page already named #{self.name} in the #{self.archive.name} archive.") if (pre_existing and self.archive)
    errors.add(:archive, "There's a page already named #{self.name} in the #{self.archive.name} archive.") if (pre_existing and self.archive)
  end
end