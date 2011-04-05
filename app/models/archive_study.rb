#The connection between an archive and a study.
#One study is kept in the system, it can be mapped to many archives with this class

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

  # accessor methods expected by app/views/ckeditor/archive_study
  def url_content
    self.path.slug
  end

  def format_created_at
    self.created_at
  end
end
