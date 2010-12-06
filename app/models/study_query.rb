class StudyQuery < ActiveRecord::Base

  validates_uniqueness_of :query
  validates_uniqueness_of :name

  before_save :clean_query

  def clean_query
    self.query.gsub!("\n", "")
    self.query.gsub!(" ", "")
  end
end
