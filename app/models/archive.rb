class Archive < ActiveRecord::Base
  include Inkling::Util::Slugs

  has_many :pages
  has_many :archive_study_blocks
  has_many :archive_study_integrations
  has_many :archive_studies, :through => :archive_study_integrations
  has_many :studies, :through => :archive_studies
  has_many :archive_study_queries
  has_many :news_archives
  has_many :news, :through => :news_archives

  validates_presence_of :name
  validates_uniqueness_of :name

  validates_presence_of :slug
  before_validation :set_slug

  ADA  = "ADA"
  SOCIAL_SCIENCE  = "Social Science"
  HISTORICAL      = "Historical"
  INDIGENOUS      = "Indigenous"
  LONGITUDINAL    = "Longitudinal"
  QUALITATIVE     = "Qualitative"
  INTERNATIONAL   = "International"

  def self.ada
    @ADA_ARCHIVE ||= self.find_by_name(ADA)
  end

  def self.social_science
    @SOCIAL_SCIENCE_ARCHIVE ||= self.find_by_name(SOCIAL_SCIENCE)
  end

  def self.historical
    @HISTORICAL_ARCHIVE ||= self.find_by_name(HISTORICAL)
  end

  def self.indigenous
    @INDIGENOUS_ARCHIVE ||= self.find_by_name(INDIGENOUS)
  end

  def self.longitudinal
    @LONGITUDINAL_ARCHIVE ||= self.find_by_name(LONGITUDINAL)
  end

  def self.qualitative
    @QUALITATIVE_ARCHIVE ||= self.find_by_name(QUALITATIVE)
  end

  def self.international
    @INTERNATIONAL_ARCHIVE ||= self.find_by_name(INTERNATIONAL)
  end

  def set_slug
    self.slug = sluggerize(name)
  end

  def to_param
    slug
  end
end
