class ArchiveCatalog < ActiveRecord::Base
  include Inkling::Util::Slugs
  
  acts_as_inkling "Catalog"
  acts_as_nested_set  

  belongs_to :archive
  belongs_to :parent, :class_name => "ArchiveCatalog"
  has_many :children, :class_name => "ArchiveCatalog", :foreign_key => "parent_id"  
  has_many :archive_catalog_studies
  
  has_one :integration

  validates_presence_of :title
  
  def generate_path_slug
    slug = ""
    if self.parent
      slug = "#{self.parent.urn}/"
      slug += sluggerize(label)    
    else
      slug = "/#{archive.slug}/browse" 
    end
    
    slug
  end
  
  def self.create_or_update_from_nesstar(hash, archive, parent = nil)
    catalog = ArchiveCatalog.find_by_title(hash["objectId"]) 

    args = {:title => hash["objectId"], 
                      :archive_id => archive.id, 
                      :catalog_position => hash["predicateIndex"],
                      :label => hash[:label]}
                      
    args[:parent_id] = parent.id if parent

    if catalog
      catalog.update_attributes(args)
    else
      catalog = ArchiveCatalog.create!(args)
    end

    catalog
  end 
end