class Page < ActiveRecord::Base
  acts_as_inkling 'Page'
  
  belongs_to :archive
  belongs_to :author, :class_name => "Inkling::User", :foreign_key => "user_id"
  
  validate :unique_archive_and_name_combination
  validates_presence_of :author
  
  
  def unique_archive_and_name_combination
    debugger
    pre_existing = self.find_by_archive_id_and_name(self.archive.id, self.name)
    
    errors.add("There's a page already named #{self.name} in the #{self.archive.name} archive") if pre_existing and self.archive
    errors.add("There's a page already named #{self.name} in ADA.") if pre_existing and self.archive.nil?
  end
end