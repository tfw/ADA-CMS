#the basic representation of a unit of data - e.g. something imported from Nesstar

class Study < ActiveRecord::Base  
  
  has_many :related_materials
  has_many :archive_study_integrations
  has_many :archive_studies
  has_many :archives, :through => :archive_studies
  has_many :variables
  
  validates_uniqueness_of :stdy_id
  validates_presence_of :stdy_id
  
  #facet constants
  FACETS = {:data_kind => (DdiMapping.human_readable('dataKind')                        || "Data Kind"),
          :sampling_abbr => (DdiMapping.human_readable('sampling')                      || "Sampling"),
          :collection_mode_abbr => (DdiMapping.human_readable('collMode')               || "Collection Mode"),
          :contact_affiliation => (DdiMapping.human_readable('stdyContactAffiliation')  ||"Contact Affiliation"),          
          :geographical_cover => (DdiMapping.human_readable('geographicalCover')        || "Geographical Cover"),
          :geographical_unit => (DdiMapping.human_readable('geographicalUnit')          || "Geographical Unit"),
          :analytic_unit => (DdiMapping.human_readable('analyticUnit')                  || "Analytic Unit"),
          :creation_date => (DdiMapping.human_readable('creationDate')                  || "Creation Date"),
          :series_name => (DdiMapping.human_readable('seriesName')                      || "Series Name"),
          :study_auth_entity => (DdiMapping.human_readable('stdyAuthEntity')            || "Study Author")
        }
        
  #solr config
  searchable do
    text :label, :default_boost => 2, :stored => true
    text :abstract, :stored => true
    text :series_name
    text :universe
    text :comment, :stored => true
    string :data_kind
    string :sampling_abbr
    string :collection_mode_abbr
    string :contact_affiliation
    string :collection_mode_abbr
    string :geographical_cover
    string :geographical_unit
    string :analytic_unit
    string :creation_date
    string :series_name
    string :study_auth_entity 
    
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
    else
      study.update_attributes(converted_keys)
    end
    
    study
  end
  
  #class behaviour to create Study objects based on a hash built from scanning an XML document
  #this code might be moved out to a builder object later on.
  def self.store_with_fields(data)
    #first, see if this is a new dataset or we're updating an old one.
    study = Study.find_by_label(data[:label])
    study = Study.new if study.nil?

    study.label = data[:label]
    study.about = data[:about]
    study.ddi_id = study.about.split(".").last
    study.resource = data[:attribute_resource]

    local_data = data.dup
    local_data.delete(:label)
    local_data.delete(:about)

    study.universe = data[:universe]
    data.delete(:universe)
    study.published = true
    study.abstract = data[:abstractText]
    data.delete(:abstractText)
    study.keywords = data[:keywords]
    data.delete(:keywords)
    study.comment = data[:comment]
    data.delete(:comment)
    study.contact_affiliation = data[:stdyContactAffiliation]
    data.delete(:stdyContactAffiliation)
    study.creation_date = data[:creationDate]
    data.delete(:creationDate)
    
    #facet data
    if data[:dataKind]      
      study.data_kind = data[:dataKind]
      data.delete(:dataKind)
    end

    #we dont delete abbreviated data, so all original data is in the study_fields table
    if data[:sampling] and data[:sampling].length < 255
      study.sampling_abbr = data[:sampling].split(/\n/).first
    end
    
    if data[:collMode] and data[:collMode].length < 255
      study.collection_mode_abbr = data[:collMode]
    end

    if data[:geographicalCover]      
      study.geographical_cover = data[:geographicalCover]
    end

    if data[:geographicalUnit]      
      study.geographical_unit = data[:geographicalUnit]
    end

    if data[:analyticUnit]      
      study.analytic_unit = data[:analyticUnit]
    end

    if data[:seriesName]      
      study.series_name = data[:seriesName]
    end
    
    if data[:stdyAuthEntity]      
      study.study_auth_entity = data[:stdyAuthEntity]
    end
    
    study.save!
    local_data.each {|k,v| create_or_update_field(study, k.to_s, v)}
    study
  end
  
  def self.create_or_update_field(study, key, value)
    begin
      study_field = StudyField.find_by_study_id_and_key(study.id, key)
    rescue
      raise StandardError, caller
    end

    if study_field
      study_field.value = value
    else
      study_field = StudyField.new(:study_id => study.id, :key => key, :value => value)
    end

    study_field.save!
  end
  
  #it would be ideal to move this logic from search_controller to study
  #but an obvious performance hit occurs when refactoring from
  #instance based searches on the controller to class level
  #calls in study!
  
  # def self.archive_search(archive, term, filters = {})
  #   Sunspot.search(Study) do ;
  #     keywords term do 
  #       highlight :label, :abstract, :comment
  #     end
  #     
  #     with(:archive_ids).any_of [archive.id];
  #     
  #     filters.each do |facet|
  #       facet.each do |name, value|
  #         with(name.to_sym, value)
  #       end
  #     end
  #     
  #     facet :data_kind
  #     facet :sampling_abbr
  #     facet :collection_mode_abbr
  #     facet :contact_affiliation
  #     facet :collection_mode_abbr
  #     facet :geographical_cover
  #     facet :geographical_unit
  #     facet :analytic_unit
  #     facet :creation_date
  #     facet :series_name
  #     facet :study_auth_entity
  #   end    
  # end
  # 
  # #we configure this manually now to ensure the archives are sorted by
  # #the mockup logic (which isnt natural). 
  # def self.search_globally
  #   {Archive.ada => self.archive_search(Archive.ada, @term),
  #    Archive.social_science => self.archive_search(Archive.social_science, @term),
  #    Archive.historical => self.archive_search(Archive.historical, @term),
  #    Archive.indigenous => self.archive_search(Archive.indigenous, @term),
  #    Archive.longitudinal => self.archive_search(Archive.longitudinal, @term),
  #    Archive.qualitative => self.archive_search(Archive.qualitative, @term),
  #    Archive.international => self.archive_search(Archive.international, @term)}
  # end
  
  
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
  
  def related_materials_attribute
    fields.find_by_key("relatedMaterials_attribute_resource")
  end

  def variables_attribute
    fields.find_by_key("variables_attribute_resource")
  end
  
  def field(key)
    field = study_fields.find_by_key(key)
    field.value if field
  end
  
  #returns the archive_study matching the archive
  def for_archive(archive)
    self.archive_studies.find_by_archive_id(archive.id)
  end
  
  def to_param
    "saved-search-#{self.title}"
  end
end
