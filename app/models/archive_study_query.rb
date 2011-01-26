class ArchiveStudyQuery < ActiveRecord::Base

  belongs_to :archive
  has_many :archive_study_integrations;
  has_many :archive_study_blocks;

  validates_uniqueness_of :query
  validates_uniqueness_of :name

  before_save :clean_query

  def clean_query
    self.query.gsub!("\n", "")
    self.query.gsub!(" ", "")
  end
end
