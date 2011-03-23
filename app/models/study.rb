#the basic representation of a unit of data - e.g. something imported from Nesstar

class Study < ActiveRecord::Base  
  
  has_many :study_fields; alias fields study_fields
  has_many :study_related_materials
  has_many :archive_study_integrations
  has_many :archive_studies
  has_many :archives, :through => :archive_studies
  
  validates :label, :presence => true
  
  searchable do
    text :label, :default_boost => 2
    text :abstract
    text :series_name
    text :universe
    text :comment
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
    
    # text :archives.id, :as => :archive_id 
    string :archive_ids, :multiple => true do
      archives.map {|archive| archive.id}
    end
    #facets
  end  
  
  
  # define_index do
  #   indexes label, :sortable => true
  #   indexes abstract
  #   indexes series_name
  #   indexes universe
  #   indexes comment
  #   indexes archives.id, :as => :archive_id 
  #   
  #   #facets
  #   # indexes data_kind, :facet => true
  #   # indexes sampling_abbr, :facet => true
  #   # indexes collection_mode_abbr, :facet => true
  #   # indexes contact_affiliation, :facet => true
  #   # indexes collection_mode_abbr, :facet => true
  #   # indexes geographical_cover, :facet => true
  #   # indexes geographical_unit, :facet => true
  #   # indexes analytic_unit, :facet => true
  #   # indexes creation_date, :facet => true
  #   # indexes series_name, :facet => true
  #   # indexes study_auth_entity , :facet => true
  # 
  #   #attributes
  #   has "CRC32(data_kind)", :as => :data_kind, :type => :integer, :facet => true
  #   has "CRC32(collection_mode_abbr)", :as => :collection_mode_abbr, :type => :integer, :facet => true
  #   has "CRC32(geographical_cover)", :as => :geographical_cover, :type => :integer, :facet => true
  #   has "CRC32(geographical_unit)", :as => :geographical_unit, :type => :integer, :facet => true
  #   has "CRC32(analytic_unit)", :as => :analytic_unit, :type => :integer, :facet => true
  #   has "CRC32(creation_date)", :as => :creation_date, :type => :integer, :facet => true
  #   has "CRC32(series_name)", :as => :series_name, :type => :integer, :facet => true
  #   has "CRC32(study_auth_entity)", :as => :study_auth_entity, :type => :integer, :facet => true
  # 
  #   # has collection_mode_abbr
  #   # has geographical_cover
  #   # has geographical_unit
  #   # has analytic_unit
  #   # has creation_date
  #   # # has "CAST(series_name AS INT)", :type => :integer, :as => :column
  #   # # has series_name
  #   # has study_auth_entity 
  #   
  #   group_by 'studies.data_kind' 
  #   group_by 'studies.collection_mode_abbr' 
  #   group_by 'studies.geographical_cover' 
  #   group_by 'studies.geographical_unit' 
  #   group_by 'studies.analytic_unit' 
  #   group_by 'studies.creation_date' 
  #   group_by 'studies.series_name' 
  #   group_by 'studies.study_auth_entity' 
  # end

  
  def title
    label
  end
  
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
    study.abstract = data[:abstract]
    data.delete(:abstract)
    study.keywords = data[:keywords]
    data.delete(:keywords)
    study.comment = data[:comment]
    data.delete(:comment)
    study.contact_affiliation = data[:stdyContactAffiliation]
    data.delete(:stdyContactAffiliation)

    # geographicalCover
    # geographicalUnit
    # analyticUnit
    # creationDate
    # seriesName
    # stdyAuthEntity


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