#The integration point between Nesstar, an archive, and a url for a study.
#This is somewhat close to a factory pattern, producing an archive, except that one instance exists for each
#archive_study to be created.

class ArchiveStudyIntegration < ActiveRecord::Base
  
  belongs_to :archive
  belongs_to :archive_study_query
  belongs_to :study
  belongs_to :user, :class_name => "Inkling::User", :foreign_key => "user_id"
  has_one :archive_study

  validates_uniqueness_of :study, :if => "self.study"
  validates_associated :archive_study, :if => "self.archive_study"
  validates_uniqueness_of :url, :with => /^http:\/\//

  after_update :create_archive_study, :if => "self.study"
 
  #if the integration references an existing study in the database (i.e. it's been downloaded as XML and converted into a Study)
  #then create the archive_study
  def create_archive_study
    archive_study = ArchiveStudy.create!(:study_id => study.id, :archive_id => archive.id, :archive_study_integration_id => self.id)
  end
  
  def resource_url
    return "http://bonus.anu.edu.au:80/obj/fStudy/au.edu.anu.assda.ddi.#{ddi_id}"
  end
end
