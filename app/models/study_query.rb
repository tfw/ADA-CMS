class StudyQuery < ActiveRecord::Base

  belongs_to :archive
  has_many :study_integrations; alias integrations study_integrations
  has_many :study_integration_blocks; alias integration_blocks study_integration_blocks 

  validates_uniqueness_of :query
  validates_uniqueness_of :name

  before_save :clean_query

  def clean_query
    self.query.gsub!("\n", "")
    self.query.gsub!(" ", "")
  end
end
