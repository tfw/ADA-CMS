#the basic representation of a unit of data - e.g. something imported from Nesstar

class Study < ActiveRecord::Base  
  
  has_many :related_materials
  has_many :archive_studies
  has_many :archives, :through => :archive_studies
  has_many :variables
  
  validates_uniqueness_of :stdy_id
  validates_presence_of :stdy_id
  
  #facet constants
  # FACETS = {:data_kind => (DdiMapping.human_readable('data_kind')                         || "Data Kind"),
  #         :sampling_abbr => (DdiMapping.human_readable('sampling')                        || "Sampling"),
  #         :collection_mode_abbr => (DdiMapping.human_readable('collection_mode')          || "Collection Mode"),
  #         :contact_affiliation => (DdiMapping.human_readable('stdy_contact_affiliation')  || "Contact Affiliation"),          
  #         :geographical_cover => (DdiMapping.human_readable('geographical_cover')         || "Geographical Cover"),
  #         :geographical_unit => (DdiMapping.human_readable('geographical_unit')           || "Geographical Unit"),
  #         :analytic_unit => (DdiMapping.human_readable('analytic_unit')                   || "Analytic Unit"),
  #         :creation_date => (DdiMapping.human_readable('creation_date')                   || "Creation Date"),
  #         :series_name => (DdiMapping.human_readable('series_name')                       || "Series Name"),
  #         :study_auth_entity => (DdiMapping.human_readable('stdy_auth_entity')            || "Study Author")
  #       }
  #       
  #solr config
  searchable :auto_index => false do
    text :label, :default_boost => 2, :stored => true
    text :abstract_text, :stored => true
    text :series_name
    text :universe
    text :comment, :stored => true
    string :data_kind
    string :sampling
    string :coll_mode
    string :geographical_cover
    string :geographical_unit
    string :analytic_unit
    string :creation_date
    string :series_name
    string :stdy_auth_entity 
    string :stdy_contact_affiliation
    
    integer :archive_ids, :multiple => true
  end  
  
  
  def self.create_or_update_from_nesstar(attributes)
    study = Study.find_by_stdy_id(attributes["stdyID"])
    
    converted_keys = {}
    attributes.each do |k,v|
      k = "pdfFile" if k == "pDFFile"
        
      converted_keys[k.underscore.to_sym] = v
    end

    if study.nil?
      study = Study.create!(converted_keys)
    elsif converted_keys[:creation_date] > study.updated_at
      study.update_attributes(converted_keys)
    end
    
    study
  end  
  
  def title
    label
  end

  def friendly_label
    bits = label.split(/\W/)
    if bits.size > 20
      friendly = bits[0..20].join(" ")
      return "#{friendly} ..."
    else
      return label
    end
  end
  
  #returns the archive_study matching the archive
  def for_archive(archive)
    self.archive_studies.find_by_archive_id(archive.id)
  end
  
  def to_param
    "saved-search-#{self.title}"
  end
  
  def ddi_id
    ddi_idx = self.stdy_id.index("ddi")
    self.stdy_id[(ddi_idx + 4)..-1]
  end
end
