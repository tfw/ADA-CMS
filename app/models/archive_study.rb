#The connection between an archive and a study.
#One study may exist in many archives, for each of which their is an archive_study

class ArchiveStudy < ActiveRecord::Base
  include Inkling::Slugs, ContentPathIncludesArchive

  acts_as_inkling 'ArchiveStudy'

  belongs_to :study
  belongs_to :archive_study_integration

  def title
    study.title
  end
end