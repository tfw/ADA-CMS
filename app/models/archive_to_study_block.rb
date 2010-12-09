class ArchiveToStudyBlock < ActiveRecord::Base

  belongs_to :archive
  belongs_to :study_query; alias query study_query
  
  validate :unique_study_and_query
  
  def unique_study_and_query
    pre_existing = ArchiveToStudyIntegration.find_by_url_and_archive_id(url, query.archive.id)
    
    if pre_existing
      unless pre_existing == self
        errors.add(:study_query, "There's already an integration between #{self.url} and #{query.archive.name}");
      end
    end
  end
  
  def resource_url
    return "http://bonus.anu.edu.au:80/obj/fStudy/au.edu.anu.assda.ddi.#{ddi_id}"
  end
end
