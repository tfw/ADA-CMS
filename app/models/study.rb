#the basic representation of a unit of data - e.g. something imported from Nesstar

class Study < ActiveRecord::Base  
  
  has_many :study_fields; alias fields study_fields
  has_many :study_related_materials
  has_many :archive_study_integrations
  has_many :archive_studies
  has_many :archives, :through => :archive_studies
  
  validates :label, :presence => true
  
  #facet constants
  FACETS = {:data_kind => (DdiMapping.find_by_ddi('dataKind').human_readable || "Data Kind"),
          :sampling_abbr => (DdiMapping.find_by_ddi('sampling').human_readable || "Sampling"),
          :collection_mode_abbr => (DdiMapping.find_by_ddi('collMode').human_readable || "Collection Mode"),
          :contact_affiliation =>  (DdiMapping.find_by_ddi('stdyContactAffiliation').human_readable ||"Contact Affiliation"),          
          :geographical_cover =>  (DdiMapping.find_by_ddi('geographicalCover').human_readable || "Geographical Cover"),
          :geographical_unit =>  (DdiMapping.find_by_ddi('geographicalUnit').human_readable || "Geographical Unit"),
          :analytic_unit =>  (DdiMapping.find_by_ddi('analyticUnit').human_readable || "Analytic Unit"),
          :creation_date =>  (DdiMapping.find_by_ddi('creationDate').human_readable || "Creation Date"),
          :series_name =>  (DdiMapping.find_by_ddi('seriesName').human_readable || "Series Name"),
          :study_auth_entity =>  (DdiMapping.find_by_ddi('stdyAuthEntity').human_readable || "Study Author")
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
  
  #class behaviour to create Study objects based on a hash built from scanning an XML document
  #this code might be moved out to a builder object later on.
  def self.store_with_entries(data)
    #first, see if this is a new dataset or we're updating an old one.
    study = Study.find_by_label(data[:label])
    study = Study.new if study.nil?

    study.label = data[:label]
    study.about = data[:about]

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
    local_data.each {|k,v| create_or_update_entry(study, k.to_s, v)}

    study
  end
  
  def self.create_or_update_entry(study, key, value)
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
  
  def ddi_id
    about.split(".").last
  end
  
  #returns the archive_study matching the archive
  def for_archive(archive)
    self.archive_studies.find_by_archive_id(archive.id)
  end
end