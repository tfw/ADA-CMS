class ArchiveCatalog < ActiveRecord::Base
  include Inkling::Util::Slugs
  
  acts_as_inkling "Catalog"
  acts_as_nested_set  

  belongs_to :parent, :class_name => "ArchiveCatalog"
  has_many :children, :class_name => "ArchiveCatalog", :foreign_key => "parent_id"  
  has_one :archive_catalog_integration
  has_many :archive_catalog_studies
  belongs_to :archive
  
  validates_presence_of :title
  
  def generate_path_slug
    slug = ""
    if self.parent
      slug = "#{self.parent.path.slug}/"
      slug += sluggerize(title)    
    else
      slug = "/#{archive.slug}/browse" #this creates /social-science/browse/foo rather than /browse/social-science/foo
    end
    
    puts "\n --- slug: #{slug} ----"
    
    slug
  end
end