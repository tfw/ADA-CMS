#Archives contain studies.
#This is also an integration point between Nesstar, an archive, and a study.

class ArchiveStudy < ActiveRecord::Base
  include Inkling::Slugs, ContentPathIncludesArchive
  
  acts_as_inkling 'ArchiveStudy'
  
  belongs_to :archive
  belongs_to :archive_study_query
  belongs_to :study
    
  validate :unique_url_and_query, :if => "self.archive_study_query"
  
  def unique_url_and_query
    pre_existing = ArchiveStudy.find_by_url_and_archive_study_query_id(url, archive_study_query.id)
    
    if pre_existing
      unless pre_existing == self
        errors.add(:study_query, "There's already a study #{self.url} kept in #{query.archive.name}");
      end
    end
  end
  
  def resource_url
    return "http://bonus.anu.edu.au:80/obj/fStudy/au.edu.anu.assda.ddi.#{ddi_id}"
  end
  
  def title
    study.title
  end

end
