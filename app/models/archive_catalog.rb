class ArchiveCatalog < ActiveRecord::Base
  include Inkling::Util::Slugs
   
  acts_as_inkling "Catalog"
  
  has_one :archive_catalog_integration
  has_one :archive_catalog_node
  belongs_to :archive
  
  validates_presence_of :title
  
  def generate_path_slug
    if self.path and self.path.parent
      slug = "#{self.path.parent.slug}/"
      slug += sluggerize(title)    
    else
      slug = "#{archive.slug}/browse/" #this creates /social-science/browse/foo rather than /browse/social-science/foo
    end
  end

end