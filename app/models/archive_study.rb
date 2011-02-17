#The connection between an archive and a study.
#One study may exist in many archives, for each of which their is an archive_study

class ArchiveStudy < ActiveRecord::Base
  include Inkling::Util::Slugs, ContentPathIncludesArchive

  acts_as_inkling 'ArchiveStudy'

  belongs_to :study
  has_many :archive_study_integrations
  belongs_to :archive

  validates_presence_of :archive
  validates_presence_of :study

  #this method creates the slug to store on the Inkling::Path (see Inkling::Path) 
  def generate_path_slug
    slug = "/#{archive.slug}/"
    slug += sluggerize(study.title)
  end
end