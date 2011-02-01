#The integration point between Nesstar, an archive, and a url for a study.
#This is somewhat close to a factory pattern, producing an archive, except that one instance exists for each
#archive_study to be created.

class ArchiveStudyIntegration < ActiveRecord::Base
  
  belongs_to :archive
  belongs_to :archive_study_query
  belongs_to :study
  has_one :archive_study

  validate :archive_study, :unique => true, :if => "self.study"
  validate :study, :unique => true, :if => "self.study"
  validate :unique_url_and_query, :if => "self.archive_study_query"

  after_update :create_archive_study, :if => "self.study"
  
  def unique_url_and_query
    pre_existing = ArchiveStudyIntegration.find_by_url_and_archive_study_query_id(url, archive_study_query.id)
    
    if pre_existing
      unless pre_existing == self
        errors.add(:study_query, "There's already a study #{self.url} kept in #{query.archive.name}");
      end
    end
  end

  #if the integration references an existing study in the database (i.e. it's been downloaded as XML and converted into a Study)
  #then create the archive_study
  def create_archive_study
    archive_study = ArchiveStudy.create!(:study_id => study.id, :archive_id => archive.id, :archive_study_integration_id => self.id)
  end
  
  def resource_url
    return "http://bonus.anu.edu.au:80/obj/fStudy/au.edu.anu.assda.ddi.#{ddi_id}"
  end
end
