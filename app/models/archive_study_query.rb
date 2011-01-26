class ArchiveStudyQuery < ActiveRecord::Base

  belongs_to :archive
  has_many :archive_studies; 
  has_many :archive_to_study_blocks; 

  validates_uniqueness_of :query
  validates_uniqueness_of :name

  before_save :clean_query

  def clean_query
    self.query.gsub!("\n", "")
    self.query.gsub!(" ", "")
  end
end
