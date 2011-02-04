#The connection between an archive and a study.
#One study may exist in many archives, for each of which their is an archive_study

class ArchiveStudy < ActiveRecord::Base
  include Inkling::Slugs, ContentPathIncludesArchive

  acts_as_inkling 'ArchiveStudy'

  belongs_to :study
  belongs_to :archive_study_integration
  belongs_to :archive

  validates :archive, :presence => true
  validates :archive_study_integration, :presence => true
  validates :archive_study_integration, :uniqueness => true
  validates :study, :presence => true

  #this method creates the slug to store on the Inkling::Path (see Inkling::Path) 
  def generate_path_slug
    slug = "/#{archive.slug}/"
    slug += sluggerize(study.title)
  end
end