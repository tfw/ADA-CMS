class Archive < ActiveRecord::Base
  include Inkling::Util::Slugs

  has_many :pages
  has_many :archive_study_blocks
  has_many :archive_study_integrations
  has_many :archive_studies, :through => :archive_study_integrations
  has_many :studies, :through => :archive_studies
  has_many :archive_catalogs
  has_many :archive_study_queries
  has_many :archive_news
  has_many :news, :through => :archive_news

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
    # @@ada_archive ||= self.find_by_name(ADA)
    self.find_by_name(ADA)
  end

  def self.social_science
    # @@social_science_archive ||= self.find_by_name(SOCIAL_SCIENCE)
    self.find_by_name(SOCIAL_SCIENCE)
  end

  def self.historical
    # @@historical_archive ||= self.find_by_name(HISTORICAL)
    self.find_by_name(HISTORICAL)
  end

  def self.indigenous
    # @@indigenous_archive ||= self.find_by_name(INDIGENOUS)
    self.find_by_name(INDIGENOUS)
  end

  def self.longitudinal
    # @@longitudinal_archive ||= self.find_by_name(LONGITUDINAL)
    self.find_by_name(LONGITUDINAL)
  end

  def self.qualitative
    # @@qualitative_archive ||= self.find_by_name(QUALITATIVE)
    self.find_by_name(QUALITATIVE)
  end

  def self.international
    # @@international_archive ||= self.find_by_name(INTERNATIONAL)
    self.find_by_name(INTERNATIONAL)
  end

  def set_slug
    self.slug = sluggerize(name)
  end
end
